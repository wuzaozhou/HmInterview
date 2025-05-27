import { PageData, QuestionItem, QuestionListParams, SortType } from "../../models"
import { http } from "../utils/Http"
import { QuestionItemComp } from "./QuestionItemComp"
import { promptAction } from "@kit.ArkUI"

enum ListLoadMoreState {
  none,// 普通状态
  loading,// 正在加载中
  noData, // 没有数据
  failure, // 加载失败
}

@ComponentV2
export struct QuestionItemList {

  @Local private refreshing: boolean = true
  @Local private moreState: ListLoadMoreState = ListLoadMoreState.none
  @Local private sort: SortType = SortType.Default
  @Local private page: number = 1
  @Local private list: QuestionItem[] = []

  @Require @Param typeId: number

  @Computed
  get loadText() {
    if (this.moreState === ListLoadMoreState.loading) {
      return "加载中..."
    }else if (this.moreState === ListLoadMoreState.noData) {
      return "没有更多数据"
    }else if (this.moreState === ListLoadMoreState.failure) {
      return "数据加载失败"
    }else {
      return "上拉加载更多"
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
    this.moreState = ListLoadMoreState.loading
    const res = await this.getQuestionList()
    this.list.push(...res.rows)
    if (this.page >= res.pageTotal) {
      this.moreState = ListLoadMoreState.noData
    } else {
      this.moreState = ListLoadMoreState.none
      this.page++
    }
  }

  async onRefresh() {
    this.moreState = ListLoadMoreState.none
    this.page = 1
    const res = await this.getQuestionList()
    this.list = res.rows
    this.refreshing = false
    if (this.page >= res.pageTotal) {
      this.moreState = ListLoadMoreState.noData
    } else {
      this.moreState = ListLoadMoreState.none
      this.page++
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
        pageSize: 10
      } as QuestionListParams
    })
  }


  build() {
    Refresh( {refreshing: $$this.refreshing}) {
      List() {
        ForEach(this.list, (item: QuestionItem, index: number) => {
          ListItem() {
            QuestionItemComp({item: item})
          }
        })
        this.loadMoreBuilder()
      }
      .onReachEnd(() => {
        this.onLoad()
      })
    }
    .onRefreshing( () => {
      this.onRefresh()
    })
  }
}
