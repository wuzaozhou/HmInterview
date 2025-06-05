import { HmNavBar } from "../../commons/components/HmNavBar"
import { Permission } from "../../commons/utils/Permission"
import { Permissions } from "@kit.AbilityKit"
import { promptAction } from "@kit.ArkUI"
import { navPathStack } from "../../commons/utils/navPathStack"
import { media } from "@kit.MediaKit"
import { fileIo } from "@kit.CoreFileKit"
import { AudioView } from "./AudioView"

@ComponentV2
export struct AudioPage {

  avRecorder?: media.AVRecorder
  fd?: number
  filePath?: string

  async startRecord() {
    // 1. 准备一个文件接收录音
    const ctx = getContext(this)
    const filePath = ctx.filesDir + '/' + Date.now() + '.m4a'
    this.filePath = filePath
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    this.fd = file.fd
    // 2. 准备路由配置对象
    const config: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
      profile: {
        audioBitrate: 100000, // 音频比特率
        audioChannels: 1, // 音频声道数
        audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前只支持aac
        audioSampleRate: 48000, // 音频采样率
        fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前只支持m4a
      },
      url: `fd://${file.fd}`
    }
    // 3. 开始录制
    const avRecorder = await media.createAVRecorder()
    await avRecorder.prepare(config)
    await avRecorder.start()
    this.avRecorder = avRecorder
  }

  async stopRecord() {
    if (this.avRecorder) {
      await this.avRecorder.stop()
      await this.avRecorder.release()
      fileIo.closeSync(this.fd)
    }
  }

  async requestPermission() {

    const permissionList: Permissions[] = [
      "ohos.permission.MICROPHONE"
    ]

    let permission = await Permission.requestPermissions(permissionList)
    if (permission) {
      return
    }
    const confirm = await promptAction.showDialog({
      title: "温馨提示",
      message: "未授权无法使用麦克风，是否前面授权",
      buttons: [
        {text: "离开", color: $r('app.color.common_gray_01')},
        {text: "去授权", color: $r('app.color.common_main_color')},
      ]
    })
    if (confirm.index === 1) {
      permission = await Permission.openPermissionSetting(permissionList)
      if (permission) {
        return
      }
    }
    navPathStack.pop()
  }

  aboutToAppear(): void {
    this.requestPermission()
  }



  build() {
    NavDestination(){
      AudioView()
    }
    .hideTitleBar(true)
  }
}

@Builder
export function AudioBuilder() {
  AudioPage()
}
