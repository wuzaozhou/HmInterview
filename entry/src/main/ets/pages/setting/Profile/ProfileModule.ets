import { Auth } from '../../../commons/utils/Auth'
import { http } from '../../../commons/utils/Http'
import { User } from '../../../models'
import { promptAction } from '@kit.ArkUI'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { HmLoadingDialog } from '../../../commons/components/HmLoadingDialog'
import fileIo from '@ohos.file.fs'
import { FormData } from '@ohos/axios'

@ObservedV2
export class ProfileModule {
  @Trace user: User = Auth.getUser()
  showLoading : (show: boolean) => void = () => {}


  async updateNick() {
    await http.request<User, User>({
      url: 'userInfo/profile',
      method: 'post',
      data: {
        nickName: this.user.nickName
      } as User
    })
    promptAction.showToast({ message: '更新昵称成功' })
    Auth.setUser(this.user)
  }

  async updateAvatar() {
    // 1. 选择相册照片
    // 选择照片配置
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.maxSelectNumber = 1
    // 选择照片对象
    const photoPicker = new photoAccessHelper.PhotoViewPicker()
    const photoResult = await photoPicker.select(photoSelectOptions)
    const uri = photoResult.photoUris[0]
    this.showLoading(true)
    // 2. 拷贝选择的图片到应用沙箱
    const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY)
    const filePath = getContext(this).cacheDir + '/' + file.name
    fileIo.copyFileSync(file.fd, filePath)
    fileIo.closeSync(file.fd)
    const formData = new FormData()
    formData.append('file', `internal://cache/${file.name}`)

    const url = await http.request<string>({
      url: 'userInfo/avatar',
      method: 'post',
      data: formData,
      headers: { 'Content-Type': 'multipart/form-data' },
      context: getContext(this)
    })
    const user = await http.request<User>({ url: 'userInfo' })
    this.user.avatar = user.avatar
    Auth.setUser(this.user)
    promptAction.showToast({ message: '更新头像成功' })
    this.showLoading(false)
  }
}
