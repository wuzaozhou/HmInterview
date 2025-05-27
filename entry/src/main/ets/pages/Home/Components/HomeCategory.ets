import { QuestionItemList } from "../../../commons/components/QuestionItemList"
import { http } from "../../../commons/utils/Http"
import { QuestionType } from "../../../models"

@Preview
@ComponentV2
export struct HomeCategory {
  @Local questionTypeList: QuestionType[] = [

  ]

  @Local activeIndex: number = 0

  @Builder TabBarBuilder(item: QuestionType, i: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }){
        Text(item.name)
          .fontSize(15)
          .fontColor(this.activeIndex === i ? $r('app.color.black') : $r('app.color.common_gray_01'))
          .height(44)
        Row()
          .visibility(this.activeIndex === i ? Visibility.Visible: Visibility.Hidden)
          .width(20)
          .height(2)
          .backgroundColor($r('app.color.black'))
          .animation({ duration: this.activeIndex === i ? 300 : 0 })
      }
      if (item.displayNewestFlag === 1) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({ left: 4 })
      }
    }
    .padding({ left: 16, right: this.questionTypeList.length === i + 1 ? 16 : 0 })
  }

  async requestQuestionTypeList() {
    const res = await http.request<QuestionType[]>({ url: 'question/type' })
    this.questionTypeList = res
  }

  aboutToAppear() {
    this.requestQuestionTypeList()
  }


  build() {
    Tabs({index: $$this.activeIndex}) {
      ForEach(this.questionTypeList, (item: QuestionType, index: number) => {
        TabContent() {
          QuestionItemList({typeId: item.id})
        }
        .tabBar(this.TabBarBuilder(item, index))
      })
    }
    .barMode(BarMode.Scrollable)
    .barHeight(44)
    .divider({strokeWidth: 0.5, color: $r('app.color.common_gray_border')})
  }
}

