@ComponentV2
export struct HmSkeleton {
  @Local opacityValue: number = 1

  @Builder
  defaultBuilder() {
  }

  @BuilderParam
  default: () => void = this.defaultBuilder

  build() {
    Row({ space: 15 }) {
      this.default()
    }
    .opacity(this.opacityValue)
    .animation({
      duration: 600,
      playMode: PlayMode.Alternate,
      iterations: -1,
      curve: Curve.EaseInOut
    })
    .onAppear(() => {
      this.opacityValue = 0.5
    })
  }
}
