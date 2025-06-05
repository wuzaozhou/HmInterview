import { HmNavBar } from "../../commons/components/HmNavBar"
import { audioDB, InterviewAudioItem } from "../../commons/utils/AudioDB"
import { AudioItemComp } from "./AudioItemComp"
import { AudioRecordComp } from "./AudioRecordComp"
import { audio } from "@kit.AudioKit"
import { Auth } from "../../commons/utils/Auth"
import { InputDialog } from "../../commons/components/InputDialog"
import { AudioPlayer } from "./AudioPlayer"


@ComponentV2
export struct AudioView {
  @Local list: InterviewAudioItem[] = [ ]
  @Local show: boolean = false
  @Local currentItem: InterviewAudioItem = {} as InterviewAudioItem

  dialog = new CustomDialogController({
    builder: InputDialog({
      name: this.currentItem.name,
      onSubmit: async (name) => {
        const item = this.currentItem
        item.name = name
        await audioDB.update(item)
        this.getList()
        this.dialog.close()
      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  @Builder
  PlayerBuilder () {
    Column(){
      AudioPlayer({ item: this.currentItem })
    }
  }

  async aboutToAppear() {
    await audioDB.initStore()
    this.getList()
  }

  async getList() {
    this.list = await audioDB.query(Auth.getUser().id)
  }

  @Builder
  ListItemSwiperBuilder(item: InterviewAudioItem) {
    Row() {
      Text('编辑')
        .actionButton($r('app.color.common_blue'))
        .onClick(() => {
          this.currentItem = item
          this.dialog.open()
        })
      Text('删除')
        .actionButton('#FF0033')
        .onClick(async () => {
          await audioDB.delete(item.id!)
          this.getList()
        })
    }
    .height('100%')
  }

  build() {
    Column() {
      HmNavBar({ title: '面试录音', showRightIcon: false })
      Column() {
        List() {
          ForEach(this.list, (item: InterviewAudioItem) => {
            ListItem() {
              AudioItemComp({
               item
              })
                .onClick(() => {
                  this.currentItem = item
                  this.show = true
                })
            }
            .swipeAction({
              end: this.ListItemSwiperBuilder(item)
            })
          })
        }
        .bindContentCover($$this.show, this.PlayerBuilder())
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .layoutWeight(1)

      AudioRecordComp({
        onRecordEnd: async  (item: InterviewAudioItem) => {
          await audioDB.insert(item)
          this.getList()
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}


@Extend(Text)
function actionButton(color: ResourceColor) {
  .width(80)
  .aspectRatio(1)
  .backgroundColor(color)
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.white'))
}
