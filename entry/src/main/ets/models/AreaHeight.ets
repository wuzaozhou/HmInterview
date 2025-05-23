
@ObservedV2
export class AreaHeight {
  @Trace topHeight: number
  @Trace bottomHeight: number

  constructor(topHeight: number, bottomHeight: number) {
    this.topHeight = topHeight
    this.bottomHeight = bottomHeight
  }
}
