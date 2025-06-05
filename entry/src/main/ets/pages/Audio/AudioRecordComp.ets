import { media } from '@kit.MediaKit'
import { fileIo } from '@kit.CoreFileKit'
import { AreaHeight } from '../../models/AreaHeight'
import { AppStorageV2 } from '@kit.ArkUI'
import { InterviewAudioItem } from '../../commons/utils/AudioDB'
import { AudioBoComp } from './AudioBoComp'
import { Auth } from '../../commons/utils/Auth'
import dayjs from '@mui/dayjs'
import { logger } from '../../commons/utils'

@ComponentV2
export struct AudioRecordComp {
  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
  @Local recording: boolean = false
  @Local maxAmplitude: number = 0
  @Local startTime: number = 0
  @Event onRecordEnd: (item: InterviewAudioItem) => void = () => {}

  avRecorder?: media.AVRecorder
  fd?: number
  filePath?: string
  timer?: number


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
    // 4. 每100ms获取一下声音振幅
    this.timer = setInterval(async () => {
      this.maxAmplitude = await avRecorder.getAudioCapturerMaxAmplitude()
    }, 100)
  }

  async stopRecord() {
    if (this.avRecorder) {
      clearInterval(this.timer)
      await this.avRecorder.stop()
      await this.avRecorder.release()
      fileIo.closeSync(this.fd)
      this.maxAmplitude = 0
    }
  }

  build() {
    Column() {
      AudioBoComp({ maxAmplitude: this.maxAmplitude })
      Row() {
        Image($r('sys.media.ohos_ic_public_voice'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
          .onClick(async () => {
            if (this.recording) {
              try {
                await this.stopRecord()
                this.recording = false
                const stat = fileIo.statSync(this.filePath)
                this.onRecordEnd({
                  id: Date.now(),
                  user_id: Auth.getUser().id,
                  name: dayjs().format('YYYY年MM月DD日_HH时mm分ss秒'),
                  path: this.filePath || '',
                  duration: Date.now()-this.startTime,
                  size: stat.size,
                  create_time: Date.now()
                })
              } catch (e) {
                logger.info(JSON.parse(e))
              }
            } else {
              await this.startRecord()
              this.recording = true
              this.startTime = Date.now()
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .height(50)
      .width(50)
      .borderRadius(25)
      .margin({ top: 20 })
      .backgroundColor(this.recording ? $r('app.color.common_main_color') : $r('app.color.black'))
    }
    .width('100%')
    .height(240)
    .backgroundColor($r('app.color.common_gray_bg'))
    .padding({ bottom: this.areaHeight.bottomHeight, left: 80, right: 80, top: 20 })
  }
}
