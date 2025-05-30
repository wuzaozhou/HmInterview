import { AreaHeight } from "../../models/AreaHeight"
import { AppStorageV2 } from "@kit.ArkUI"
import { navPathStack } from "../../commons/utils/navPathStack"
import { SearchHistory } from "./SearchHistory"
import { QuestionItemList } from "../../commons/components/QuestionItemList"
import { history } from "./History"

@ComponentV2
export struct SearchPage {
  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
  @Local keyword: string = ''
  @Local isSearch: boolean = false

  @Monitor("isSearch") keywordChange() {
    history.setItem(this.keyword)
  }

  build() {
    NavDestination() {
      Column() {
        Row({ space: 16 }) {
          Search({ placeholder: '请输入试题关键字', value: this.keyword })
            .placeholderFont({ size: 14 })
            .height(32)
            .layoutWeight(1)
            .defaultFocus(true)
            .onSubmit((value) => {
              this.keyword = value
              this.isSearch = true
            })
            .onChange((value) => {
              if (!value) {
                this.keyword = value
                this.isSearch = false
              }
            })
          Text('取消')
            .fontColor($r('app.color.black'))
            .fontSize(15)
            .fontWeight(500)
            .onClick(() => {
              navPathStack.pop()

            })
        }
        .height(64)
        .padding({ left: 16, right: 16 })
        .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })

        Column() {
          if (this.isSearch) {
            QuestionItemList({
              typeId: 0,
              keyword: this.keyword
            })
          } else {
            SearchHistory({
              onSearch: keyword => {
                this.keyword = keyword
                this.isSearch = true
              }
            })
          }
        }
        .layoutWeight(1)
      }
      .padding({ top: this.areaHeight.topHeight })
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)

  }
}

@Builder
export function SearchBuilder() {
  SearchPage()
}
