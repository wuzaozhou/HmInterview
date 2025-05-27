import { QuestionItem } from "../../models"
import { HmTag } from "./HmTag"

@Preview
@ComponentV2
export struct QuestionItemComp {
  @Param item: QuestionItem = {
    id: '111',
    stem: 'ArkUI的容器组件有哪些？',
    difficulty: 5,
    likeCount: 200,
    views: 200,
    readFlag: 0
  }

  build() {
    Column({ space: 10 }) {
      Row({ space: 5 }) {
        HmTag({difficulty: this.item.difficulty})
        Text(this.item.stem)
          .fontSize(15)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(500)
      }
      .width('100%')

      RowSplit() {
        Text('点赞 '+ this.item.likeCount.toString())
          .grayText(true)
        Text('浏览 ' + this.item.views.toString())
          .grayText()
        if (this.item.readFlag === 1) {
          Text('已看过')
            .grayText()
        }
      }
    }
    .padding({ left: 16, right: 16 })
    .width('100%')
    .height(80)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }
}
@Extend(Text)
function grayText(isStart: boolean = false) {
  .lineHeight(13)
  .fontSize(13)
  .fontColor($r('app.color.common_gray_01'))
  .padding({ left: isStart ? 0 : 12, right: 12 })
}
