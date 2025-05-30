import { HmNavBar } from "../../commons/components/HmNavBar"
import { HmTag } from "../../commons/components/HmTag"
import { AreaHeight } from "../../models/AreaHeight"
import { AppStorageV2, promptAction } from "@kit.ArkUI"
import { navPathStack } from "../../commons/utils/navPathStack"
import { QuestionDetail, QuestionOptParams, QuestionPageParams } from "../../models"
import { http } from "../../commons/utils/Http"
import { webview } from "@kit.ArkWeb"
import { HmLoadingDialog } from "../../commons/components/HmLoadingDialog"
import { QuestionShareDialog } from "./components/QuestionShare"
import { tracking } from "../../commons/utils/Tracking"
import { data } from "@kit.TelephonyKit"

@ComponentV2
export struct QuestionPage {
  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
  @Local item: QuestionDetail = {} as QuestionDetail
  @Local list: QuestionDetail[] = []
  @Local index: number = 0
  @Local startTime: number = Date.now()// 记录开始学习的时间

  controller = new webview.WebviewController()
  loading = new CustomDialogController({
    builder: HmLoadingDialog(),
    customStyle: true
  })
  shareDialog = new CustomDialogController({
    builder: QuestionShareDialog({
      item: this.item
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  @Builder TitleBuilder(text: string) {
    Row() {
      Text()
        .width(2)
        .height(12)
        .backgroundColor($r('app.color.black'))
        .margin({ right: 13 })
      Text(text)
        .fontWeight(700)
    }
    .width('100%')
    .padding({ top: 10 })
    .height(32)
  }

  @Builder MenuBuilder() {
    Menu() {
      MenuItem({ content: this.item.likeFlag ? '取消点赞':'点赞' })
        .onClick(async () => {
          this.questionOpt(1, this.item.likeFlag ?  0 : 1)
        })
      MenuItem({ content: this.item.collectFlag ? '取消收藏':'收藏' })
        .onClick(async () => {
          this.questionOpt(2, this.item.collectFlag ?  0 : 1)
        })
      MenuItem({ content: '点我反馈' })
      MenuItem({ content: '试题分享' })
        .onClick(() => {
          this.shareDialog.open()
        })
    }
    .width(108)
  }

  toggleQuestion(step: number) {
    const index = this.index + step
    if (index < 0 || index > this.list.length - 1) {
      promptAction.showToast({message : "没有更多题目了"})
      return
    }

    tracking.record(this.startTime, Date.now(), this.item.id)
    this.startTime = Date.now()
    this.index = index
    this.item = this.list[index]
    this.questionItem()
  }

  async questionOpt(optType: 1 | 2, flag: 0 | 1) {
    this.loading.open()
    try {
      const data: QuestionOptParams = {
        id: this.item.id,
        type: 0,
        optType
      }
      // flag 是你要执行的操作 执行 | 取消
      await http.request<null, QuestionOptParams>({
        url: flag === 1 ? 'question/opt' : 'question/unOpt',
        method: 'post',
        data
      })
      this.loading.close()
      if (optType === 1) {
        this.item.likeFlag = flag
        promptAction.showToast({ message: flag ? '点赞成功' : '取消点赞' })
      }
      if (optType === 2) {
        this.item.collectFlag = flag
        promptAction.showToast({ message: flag ? '收藏成功' : '取消收藏' })
      }

    } catch (e) {
      this.loading.close()
      promptAction.showToast({ message: '操作失败' })

    }
  }

  async questionItem() {
    if (this.item.answer) {
      return
    }
    this.loading.open()
    try {
      const item = await http.request<QuestionDetail>({
        url: 'question/'+this.item.id
      })
      this.list[this.index] = item
      this.item = item
      this.controller.loadUrl($rawfile('question.html'))
    } catch (e) {
      this.loading.close()
    }
  }

  aboutToAppear() {

    const param = navPathStack.getParamByName('QuestionPage').pop() as QuestionPageParams
    if (param) {
      this.item = param.item as QuestionDetail
      this.list = param.list as QuestionDetail[]
      this.index = this.list.findIndex(item => item.id === this.item.id)
    }
    this.questionItem()
  }


  build() {
    NavDestination() {
      Column() {
        HmNavBar({ title: '试题详情', showRightIcon: false })
        // 题目
        this.TitleBuilder('题目：')
        Text(this.item.stem || '')
          .width('100%')
          .padding(16)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Row({ space: 12 }) {
          ForEach(this.item.stage, (tag: string)=> {
            HmTag({text: tag})
          })
          Blank()
          Image($r("app.media.ic_home_more"))
            .width(20)
            .aspectRatio(1)
            .bindMenu(this.MenuBuilder())
        }
        .width('100%')
        .padding({ bottom: 16, left: 16, right: 16 })

        Divider()
          .strokeWidth(8)
          .color($r('app.color.common_gray_bg'))
        // 内容
        this.TitleBuilder('答案：')

        Web({
          src: $rawfile('question.html'),
          controller: this.controller
        })
          .onPageEnd(() => {
            if (this.item.answer) {
              this.controller.runJavaScript(`writeHtml(\`${this.item.answer}\`)`);
            }
            this.loading.close()
          })
          .width('100%')
          .layoutWeight(1)



        Row({ space: 80 }) {
          Row() {
            Image($r('sys.media.ohos_ic_public_arrow_left'))
              .width(20)
              .aspectRatio(1)
              .fillColor(this.index <= 0 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
            Text(' 上一题')
              .fontColor(this.index <= 0 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
          }
          .onClick(() => {
            this.toggleQuestion(-1)
          })

          Row() {
            Text('下一题 ')
              .fontColor(this.index >= this.list.length-1 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
            Image($r('sys.media.ohos_ic_public_arrow_right'))
              .width(20)
              .aspectRatio(1)
              .fillColor(this.index >= this.list.length-1 ? $r('app.color.common_gray_01') : $r('app.color.common_gray_03'))
          }
          .onClick(() => {
            this.toggleQuestion(1)
          })
        }
        .height(44)
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .padding({ bottom: this.areaHeight.bottomHeight })
    }
    .hideTitleBar(true)
    .onShown(() => {
      this.startTime = Date.now()
    })
    .onHidden(() => {
      tracking.record(this.startTime, Date.now(), this.item.id)
      tracking.report(false)
    })
  }
}

@Builder
export function QuestionBuilder() {
  QuestionPage()
}

