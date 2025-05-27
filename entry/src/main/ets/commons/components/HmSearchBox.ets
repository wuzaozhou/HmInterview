
@ComponentV2
export struct HmSearchBox {
  @Param boxRadius: number = 16
  @Param ph: ResourceStr = '搜索内容'
  @Param phColor: ResourceColor = $r('app.color.common_gray_02')
  @Param bgColor: ResourceColor = $r('app.color.common_gray_border')



  build() {
    Row({space: 5}) {
      Image($r('app.media.ic_common_search'))
        .width(14)
        .aspectRatio(1)
        .fillColor(this.phColor)
      Text('请输入搜索关键字')
        .fontSize(14)
        .fontColor(this.phColor)
    }
    .width('100%')
    .height(32)
    .backgroundColor(this.bgColor)
    .borderRadius(this.boxRadius)
    .justifyContent(FlexAlign.Center)
  }
}
