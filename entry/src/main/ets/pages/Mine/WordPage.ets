
import { util } from "@kit.ArkTS"
import { HmNavBar } from "../../commons/components/HmNavBar"
import { WordItem } from "../../models"
import { WordDialog } from "./Components/WordDialog"
import { media } from "@kit.MediaKit"

type Words = Record<string, WordItem[]>

@Preview
@ComponentV2
export struct WordPage {

  words: Words = {}
  scroller: Scroller = new Scroller()

  @Local wordKey: string = ''
  @Local showTypeSheet: boolean = false
  @Local currentEn: string = ''
  @Local currentZh: string = ''
  dialog = new CustomDialogController({
    builder: WordDialog({ en: this.currentEn, zh: this.currentZh }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  @Builder
  TypeSheetBuilder() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(Object.keys(this.words), (key: string) => {
          Button() {
            Text(key)
              .fontSize(14)
              .fontColor(key === this.wordKey ? $r('app.color.common_green') : $r('app.color.common_gray_01'))
          }
          .backgroundColor($r('app.color.common_gray_bg'))
          .padding({ top: 6, right: 12, bottom: 6, left: 12 })
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            this.wordKey = key
            this.showTypeSheet = false
            this.scroller.scrollEdge(Edge.Top)
          })
        })
      }
    }
    .padding({ left: 16, right: 16, top: 8, bottom: 34 })
  }


  initWords() {
    const ctx = getContext(this)
    // 获取二进制数据
    const uint8Array = ctx.resourceManager.getRawFileContentSync('word.json')
    // 实例化文本解析工具
    const textDecoder = new util.TextDecoder()
    // 解析文本
    // const jsonStr = textDecoder.decodeWithStream(uint8Array)
    const jsonStr = textDecoder.decodeToString(uint8Array)  // API12+
    // 转成对象
    this.words = JSON.parse(jsonStr) as Words

    this.wordKey = Object.keys(this.words)[0]
  }

  aboutToAppear(): void {
    this.initWords()
  }





  build() {
    NavDestination() {
      Column() {
        HmNavBar({
          title: "常用单词",
          showRightIcon: false
        })

        Row() {
          Column({ space: 4 }) {
            Text('开发常用词汇')
            Text(`共 ${this.words[this.wordKey].length} 个单词`)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_03'))
          }
          .alignItems(HorizontalAlign.Start)
          Row() {
            Text(this.wordKey)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_01'))
            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_gray_01'))
          }
          .bindSheet($$this.showTypeSheet, this.TypeSheetBuilder(), {
            height: 400,
            title: {title: "选择阶段"},
            backgroundColor: $r('app.color.white')
          })
          .onClick(() => {
            this.showTypeSheet = true
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(16)
        .border({ width: { top: 0.5 }, color: $r('app.color.common_gray_bg') })

        Divider()
          .strokeWidth(8)
          .color($r('app.color.common_gray_bg'))

        List({scroller: this.scroller}) {
          ForEach(this.words[this.wordKey], (item: WordItem) => {

            ListItem() {
              Row({ space: 6 }) {
                Image($r('sys.media.ohos_ic_public_sound'))
                  .width(20)
                  .aspectRatio(1)
                  .alignSelf(ItemAlign.Start)
                  .fillColor($r('app.color.common_gray_03'))
                Column({ space: 10 }) {
                  Text(item.en)
                    .fontWeight(FontWeight.Bold)
                  Text(item.zh)
                    .fontSize(14)
                    .fontColor($r('app.color.common_gray_03'))
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Row() {
                  Text('详细代码')
                    .fontSize(12)
                    .fontColor(item.code ? $r('app.color.common_gray_01') : '#dddddd')
                  Image($r('sys.media.ohos_ic_public_arrow_right'))
                    .width(16)
                    .aspectRatio(1)
                    .fillColor(item.code ? $r('app.color.common_gray_01'): '#dddddd')
                }
                .alignSelf(ItemAlign.End)
              }
              .padding(16)
            }
              .onClick(() => {
                this.currentEn = item.en
                this.currentZh = item.zh
                this.dialog.open()
              })
          })
        }
        .divider({
          strokeWidth: 0.5,
          color: $r('app.color.common_gray_bg')
        })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')

    }
    .hideTitleBar(true)
  }
}

@Builder
export function WordBuilder() {
  WordPage()
}
