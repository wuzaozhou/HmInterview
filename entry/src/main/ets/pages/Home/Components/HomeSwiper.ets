@ComponentV2
export struct HomeSwiper {
  @Param swiperList: ResourceStr[] = []

  @Builder SwiperItemBuilder(item: ResourceStr, i: number) {
    Image(item)
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Fill)
      .borderRadius(10)
  }


  build() {
    Swiper() {
      ForEach(this.swiperList, (item: ResourceStr, index: number) => {
        this.SwiperItemBuilder(item, index)
      })
    }
    .width('100%')
    .aspectRatio(2.66)
    .padding({left: 16, right: 16})
  }
}
