import { AreaHeight } from "../../models/AreaHeight"
import { App, AppStorageV2, promptAction } from "@kit.ArkUI"
import { HmSearchBox } from "../../commons/components/HmSearchBox"
import { HmClockIn } from "../../commons/components/HmClockIn"
import { HomeSwiper } from "./Components/HomeSwiper"
import { HomeCategory } from "./Components/HomeCategory"
import { AppUser, QuestionDetail, QuestionPageParams, User } from "../../models"
import { Auth } from "../../commons/utils/Auth"
import { scanBarcode } from "@kit.ScanKit"
import { http } from "../../commons/utils/Http"
import { navPathStack } from "../../commons/utils/navPathStack"
import { tracking } from "../../commons/utils/Tracking"
import { requestClockIn } from "../../commons/utils/ClockIn"


@ComponentV2
export struct HomePage {
  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
  @Local user: User = Auth.getUser()
  @Local swiperList: ResourceStr[] = [
    $r('app.media.banner_qa'),
    $r('app.media.banner_pj'),
    $r('app.media.banner_ai'),
  ]
  async scanQuestionCode() {
    if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
      const result = await scanBarcode.startScanForResult(getContext(this))
      if (result.originalValue) {
        try {
          const item = await http.request<QuestionDetail>({ url: `question/${result.originalValue}` })
          navPathStack.pushPath({
            name: 'QuestionPage',
            param : {
              item,
              list: [item]
            } as QuestionPageParams
          })

        } catch (e) {
          promptAction.showToast({ message: '没有找到试题' })
        }
      }
    }
  }

  aboutToAppear(): void {
    tracking.report()
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            Auth.checkAuth(() => {
              this.scanQuestionCode()
            })
          })
        HmSearchBox({
          boxRadius: 16
        })
          .layoutWeight(1)
          .height(32)
          .onClick(() => {
            navPathStack.pushPath({
              name: 'SearchPage',
            }, {
              launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON
            })
          })
        HmClockIn({
          clockInCount: this.user.clockinNumbers
        })
          .onClick(() => {
            requestClockIn()

          })

      }
      .padding({ left: 16, right: 16 })
      .height(64)
      .width('100%')
      HomeSwiper({swiperList: this.swiperList})
      HomeCategory()
        .layoutWeight(1)
        .width('100%')
    }
    .padding({ top: this.areaHeight.topHeight })
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.common_gray_bg'))
  }
}
