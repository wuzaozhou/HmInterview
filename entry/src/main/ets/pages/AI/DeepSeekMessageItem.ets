import { AppUser } from "../../models"
import { MessageItem } from "./model"
import { PersistenceV2 } from "@kit.ArkUI"


@ComponentV2
export struct DeepSeekMessageItem {

  @Param item: MessageItem = {} as MessageItem
  @Local appUser: AppUser = PersistenceV2.connect(AppUser, () => new AppUser())!

  @Builder
  getAvatar() {
    if (this.item.role === 'system') {
      Image($r('app.media.ic_mine_avatar'))
        .width(30)
        .aspectRatio(1)
        .borderRadius(15)
    }else {
      Image(this.appUser.user.avatar || $r('app.media.ic_mine_avatar'))
        .width(30)
        .aspectRatio(1)
        .borderRadius(15)
    }

  }

  build() {
    Row({space: 20}) {
      this.getAvatar()
      Row() {
        Text(this.item.content)
          .borderRadius(10)
          .padding(10)
          .lineHeight(24)
          .backgroundColor(this.item.role === 'system' ? "#f8fafb" : "#3273e8")
          .fontColor(this.item.role === 'system' ? "#373737" : "#fff")
          .constraintSize({
            minWidth: 40
          })
      }
      .layoutWeight(1)
      .justifyContent(this.item.role === 'system' ? FlexAlign.Start : FlexAlign.End)

      Row().width(50)
    }
    .direction(this.item.role === 'system' ? Direction.Ltr : Direction.Rtl) // 反转方向
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }
}
