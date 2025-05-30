import { HmSkeleton } from "../../../commons/components/Skeleton/HmSkeleton"
import { HmSkeletonItem } from "../../../commons/components/Skeleton/HmSkeletonItem"


@ComponentV2
export struct HomeMainSkeleton {
  build() {
    HmSkeleton() {
      Column() {
        Row({ space: 16 }) {
          HmSkeletonItem({ widthValue: 60 })
          HmSkeletonItem({ widthValue: 100 })
          HmSkeletonItem({ widthValue: 80 })
          HmSkeletonItem({ widthValue: 40 })
        }
        .height(44)
        .width('100%')

        ForEach([1, 2, 3, 4, 5, 6], () => {
          Column({ space: 10 }) {
            HmSkeletonItem({ widthValue: '90%' })
            HmSkeletonItem({ widthValue: '45%' })
          }
          .height(80)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        })
      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .height('100%')
    }
  }
}
