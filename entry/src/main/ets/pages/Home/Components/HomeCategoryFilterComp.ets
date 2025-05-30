import { FilterButton } from "../../../commons/components/FilterButton"
import { QuestionType, SortType } from "../../../models"


@ComponentV2
export struct HomeCategoryFilterComp {

  @Param activeIndex: number = 0
  @Param sort: SortType = SortType.Default
  @Param questionTypeList: QuestionType[] = []
  @Local filterSort: SortType = this.sort
  @Local filterDataIndex: number = this.activeIndex
  @Event onClickDone: (index: number, sort: SortType) => void = (index: number, sort: SortType) => {}
  @Event onClickClose: () => void = () => {}

  private viewArr: SortType[] = [SortType.ViewLow, SortType.ViewHigh]
  private difficultyArr: SortType[] = [SortType.DifficultyLow, SortType.DifficultyHigh]

  build() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
          .onClick(() => {
            this.onClickClose()
          })
        Text('筛选题目')
          .layoutWeight(1)
          .fontSize(18)
          .fontWeight(500)
          .fontColor($r('app.color.black'))
          .textAlign(TextAlign.Center)
        Text('完成')
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('app.color.common_main_color'))
          .onClick(() => {
            this.onClickDone(this.filterDataIndex, this.filterSort)
          })
      }
      .margin({ bottom: 4, top: 4 })

      Text('题目排序')
        .textTitle()
      // 排序方式
      Flex({ wrap: FlexWrap.Wrap }) {
        FilterButton({ text: '默认', selected: this.filterSort === SortType.Default})
          .onClick(()=> {
            this.filterSort = SortType.Default
          })
        FilterButton({
          text: '浏览量',
          isSort: true,
          selected: this.viewArr.includes(this.filterSort),
          sort: this.filterSort
        })
          .onClick(() => {
            this.filterSort === SortType.ViewHigh ? this.filterSort = SortType.ViewLow : this.filterSort = SortType.ViewHigh
          })
        FilterButton({
          text: '难度',
          isSort: true,
          selected: this.difficultyArr.includes(this.filterSort),
          sort: this.filterSort
        }).onClick(() => {
          this.filterSort === SortType.DifficultyLow ? this.filterSort = SortType.DifficultyHigh : this.filterSort = SortType.DifficultyLow
        })
        FilterButton({ text: '推荐', selected: this.filterSort === SortType.Commend})
          .onClick(() => {
            this.filterSort = SortType.Commend
          })
      }
      Text('选择分类')
        .textTitle()
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.questionTypeList, (item: QuestionType, index: number) => {
          FilterButton({
            text: item.name,
            isNew: item.displayNewestFlag === 1,
            selected: index === this.filterDataIndex
          })
            .onClick(() => {
              this.filterDataIndex = index
            })
        })
      }
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .height('100%')
  }
}

@Extend(Text)
function textTitle() {
  .fontSize(14)
  .fontWeight(500)
  .fontColor($r('app.color.black'))
  .width('100%')
  .margin({ top: 20 })
}
