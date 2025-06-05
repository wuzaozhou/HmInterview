import { HmNavBar } from "../../../commons/components/HmNavBar"
import { User } from "../../../models"
import { HmLoadingDialog } from "../../../commons/components/HmLoadingDialog"
import { Auth } from "../../../commons/utils/Auth"
import { ProfileModule } from "./ProfileModule"

@ComponentV2
export struct ProfilePage {

  @Local module: ProfileModule = new ProfileModule()
  dialog: CustomDialogController = new CustomDialogController({
    builder: HmLoadingDialog({ message: '更新中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  aboutToAppear() {
    this.module.showLoading = (show) => {
      if (show) {
        this.dialog.open()
      }else {
        this.dialog.close()
      }
    }
  }


  build() {
    NavDestination(){
      Column() {
        HmNavBar({
          title: '编辑资料',
          showRightIcon: false
        })
        Row() {
          Text("头像")
            .fontSize(16)
            .fontColor($r('app.color.black'))
          Image(this.module.user.avatar)
            .alt($r('app.media.ic_mine_avatar'))
            .width(40)
            .aspectRatio(1)
            .borderRadius(20)
            .onClick(() => {
              this.module.updateAvatar()
            })
        }
        .rowStyle()

        Divider()
          .backgroundColor($r('app.color.common_gray_03'))
          .marginStyle()
        Row() {
          Text("昵称")
            .fontSize(16)
            .fontColor($r('app.color.black'))
          TextInput({
            text: this.module.user.nickName || this.module.user.username,
            placeholder: this.module.user.nickName || this.module.user.username
          })
            .layoutWeight(1)
            .textAlign(TextAlign.End)
            .backgroundColor($r('app.color.white'))
            .borderRadius(0)
            .fontSize(16)
            .fontColor($r('app.color.black'))
            .onChange((value)=> this.module.user.nickName = value)
            .onSubmit(() => {
              this.module.updateNick()
            })
        }
        .rowStyle()

      }



    }
    .hideTitleBar(true)
  }
}

@Extend(Row)
function rowStyle() {
  .alignItems(VerticalAlign.Center)
  .justifyContent(FlexAlign.SpaceBetween)
  .width('100%')
  .height(50)
  .padding({
    left: 15,
    right: 15
  })
}

@Styles
function marginStyle() {
  .margin({
    left: 15,
    right: 15
  })
}
@Builder
export function ProfileBuilder() {
  ProfilePage()
}
