import { AreaHeight } from "../../models/AreaHeight"
import { AppStorageV2 } from "@kit.ArkUI"
import { HmSearchBox } from "../../commons/components/HmSearchBox"
import { HmClockIn } from "../../commons/components/HmClockIn"
import { HomeSwiper } from "./Components/HomeSwiper"
import { HomeCategory } from "./Components/HomeCategory"


@ComponentV2
export struct HomePage {

  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
  @Local swiperList: ResourceStr[] = [
    $r('app.media.banner_qa'),
    $r('app.media.banner_pj'),
    $r('app.media.banner_ai'),
  ]



  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
        HmSearchBox({
          boxRadius: 16
        })
          .layoutWeight(1)
          .height(32)
        HmClockIn({
          clockInCount: 4
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
