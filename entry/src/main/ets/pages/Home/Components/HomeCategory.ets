import { FilterButton } from "../../../commons/components/FilterButton"
import { QuestionItemList } from "../../../commons/components/QuestionItemList"
import { http } from "../../../commons/utils/Http"
import { AppUser, QuestionType, SortType, User } from "../../../models"
import { HomeCategoryFilterComp } from "./HomeCategoryFilterComp"
import { HomeMainSkeleton } from "./HomeMainSkeleton"
import { AppStorageV2 } from "@kit.ArkUI"
import { Auth } from "../../../commons/utils/Auth"

@Preview
@ComponentV2
export struct HomeCategory {
  @Local questionTypeList: QuestionType[] = []

  @Local activeIndex: number = 0
  @Local sort: SortType = SortType.Default
  @Local isShow: boolean = false
  @Local isLoading: boolean = false

  @Local user: User = Auth.getUser()
  @Monitor("user.token")
  tokenChange() {
    this.requestQuestionTypeList()
  }

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
    .padding({ left: 16, right: this.questionTypeList.length === i + 1 ? 56 : 0 })
  }

  async requestQuestionTypeList() {
    this.isLoading = true
    const res = await http.request<QuestionType[]>({ url: 'question/type' })
    this.questionTypeList = res || []
    this.isLoading = false
  }

  @Builder FilterSheetBuilder() {

    HomeCategoryFilterComp({
      sort: this.sort,
      activeIndex: this.activeIndex,
      questionTypeList: this.questionTypeList,
      onClickDone: ((index: number, sort: SortType) => {
        this.activeIndex = index
        this.sort = sort
        this.isShow = false
      }),
      onClickClose: (() => {
        this.activeIndex = 0
        this.sort = SortType.Default
        this.isShow = false
      }),

    })
  }

  aboutToAppear() {
    this.requestQuestionTypeList()
  }

  build() {
    if (this.isLoading) {
      HomeMainSkeleton()
        .backgroundColor(Color.White)
    }else {
      Stack({alignContent: Alignment.TopEnd}) {
        Tabs({index: $$this.activeIndex}) {
          ForEach(this.questionTypeList, (item: QuestionType, index: number) => {
            TabContent() {
              QuestionItemList({
                typeId: item.id,
                sort: this.sort,
                activeIndex: this.activeIndex,
                index: index
              })
            }
            .tabBar(this.TabBarBuilder(item, index))
          })
        }
        .barMode(BarMode.Scrollable)
        .barHeight(44)
        .divider({strokeWidth: 0.5, color: $r('app.color.common_gray_border')})
        .onTabBarClick((index: number) => {
          this.activeIndex = index
        })
        Row(){
          Image($r('app.media.ic_home_filter'))
            .width(24)
            .aspectRatio(1)
        }
        .width(56)
        .height(44)
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 90,
          colors: [
            ["#00ffffff", 0],
            ["#ffffff", 0.3]
          ]
        })
        .bindSheet($$this.isShow, this.FilterSheetBuilder(), {
          showClose: false,
          height: 400,
        })
        .onClick(() => {
          this.isShow = true
        })
      }
    }

  }
}


