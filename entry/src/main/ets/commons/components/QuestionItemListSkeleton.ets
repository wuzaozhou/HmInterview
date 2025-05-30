import { HmSkeleton } from "./Skeleton/HmSkeleton"
import { HmSkeletonItem } from "./Skeleton/HmSkeletonItem"

@ComponentV2
export struct QuestionItemSkeleton {
  build() {
    HmSkeleton() {
      Column() {
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
