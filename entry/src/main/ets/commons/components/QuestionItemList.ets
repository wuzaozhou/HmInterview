import { PageData, QuestionItem, QuestionListParams, QuestionPageParams, SortType } from "../../models"
import { http } from "../utils/Http"
import { QuestionItemComp } from "./QuestionItemComp"
import { promptAction } from "@kit.ArkUI"
import { QuestionItemSkeleton } from "./QuestionItemListSkeleton"
import { navPathStack } from "../utils/navPathStack"
import { Auth } from "../utils/Auth"

enum ListLoadMoreState {
  none,// 普通状态
  loading,// 正在加载中
  noData, // 没有数据
  failure, // 加载失败
}

@ComponentV2
export struct QuestionItemList {
  @Local private showSkeleton: boolean = true
  @Local private refreshing: boolean = true
  @Local private moreState: ListLoadMoreState = ListLoadMoreState.none

  @Local private page: number = 1
  @Local private list: QuestionItem[] = []

  @Param keyword: string = ""
  @Require @Param typeId: number
  @Param sort: SortType = SortType.Default
  @Param index: number = 0
  @Param activeIndex: number = 0

  @Monitor("sort", "activeIndex", "keyword") sortChange() {
    if (this.activeIndex != this.index) {
      return
    }
    this.refreshing = true
  }


  @Computed
  get loadText() {
    if (this.moreState === ListLoadMoreState.loading) {
      return "加载中..."
    }else if (this.moreState === ListLoadMoreState.noData) {
      return "没有更多数据"
    }else if (this.moreState === ListLoadMoreState.failure) {
      return "数据加载失败"
    }else {
      return ""
    }
  }

  @Builder loadMoreBuilder () {
    ListItem() {
      Row() {
        if (this.moreState === ListLoadMoreState.loading) {
          LoadingProgress()
            .width(20)
        }
        Text(this.loadText)
          .fontSize(14)
          .fontColor($r('app.color.common_gray_03'))
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(80)
    }
  }

  async onLoad() {
    if (this.moreState === ListLoadMoreState.loading ||
      this.moreState === ListLoadMoreState.noData || this.list.length == 0) {
      return
    }
    try {
      this.moreState = ListLoadMoreState.loading
      const res = await this.getQuestionList()
      this.list.push(...res.rows)
      if (this.page >= res.pageTotal) {
        this.moreState = ListLoadMoreState.noData
      } else {
        this.moreState = ListLoadMoreState.none
        this.page++
      }
    } catch (e) {
      this.moreState = ListLoadMoreState.none
    }
  }

  async onRefresh() {
    try {
      this.moreState = ListLoadMoreState.none
      this.page = 1
      const res = await this.getQuestionList()
      this.showSkeleton = false
      this.list = res.rows
      this.refreshing = false
      if (this.page >= res.pageTotal) {
        this.moreState = ListLoadMoreState.noData
      } else {
        this.moreState = ListLoadMoreState.none
        this.page++
      }
    } catch (e) {
      this.refreshing = false
    }
  }

  getQuestionList(): Promise<PageData<QuestionItem>> {
    return http.request<PageData<QuestionItem>>({
      url: 'question/list',
      params: {
        type: this.typeId,
        questionBankType: 10,
        sort: this.sort,
        page: this.page,
        pageSize: 10,
        keyword: this.keyword
      } as QuestionListParams
    })
  }


  build() {
    Refresh( {refreshing: $$this.refreshing}) {
      if (this.showSkeleton) {
        QuestionItemSkeleton()
      }else {
        List() {
          ForEach(this.list, (item: QuestionItem, index: number) => {
            ListItem() {
              QuestionItemComp({item: item})
                .onClick(() => {
                  navPathStack.pushPath({
                    name: 'QuestionPage',
                    param: {
                      item: item,
                      list: this.list
                    } as QuestionPageParams
                  })
//                  Auth.checkAuth({
//                    name: 'QuestionPage',
//                    param: {item} as QuestionPageParams
//                  } as NavPathInfo)
                })
            }
          })
          this.loadMoreBuilder()
        }

        .onReachEnd(() => {
          this.onLoad()
        })
        .width('100%')
        .height('100%')
      }
    }
    .onRefreshing( () => {
      this.onRefresh()
    })
    .backgroundColor($r('app.color.white'))
  }
}
