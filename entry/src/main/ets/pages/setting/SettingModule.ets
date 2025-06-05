import { fileIo, storageStatistics } from "@kit.CoreFileKit"
import { promptAction } from "@kit.ArkUI"
import { bundleManager } from "@kit.AbilityKit"

@ObservedV2
export class SettingModule {
  @Trace cache: string = ""
  @Trace version: string = ''

  getVersion() {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      .then(res => {
        this.version = "v " + res.versionName
      })
  }

  calcCache() {
    storageStatistics.getCurrentBundleStats().then( res => {
      this.cache = (res.cacheSize / (1000 * 1000)).toFixed(2) + 'MB'
    })
  }

  clearCache() {
    const ctx = getContext()
    const ctxCacheDir = ctx.cacheDir
    const ctxExist = fileIo.accessSync(ctxCacheDir)
    if (ctxExist) {
      fileIo.rmdirSync(ctxCacheDir)
    }
    const app = ctx.getApplicationContext()
    const appCacheDir = app.cacheDir
    const appExist = fileIo.accessSync(appCacheDir)
    if (appExist) {
      fileIo.rmdirSync(appCacheDir)
    }
    promptAction.showToast({ message: '清理完毕' })
    this.calcCache()
  }


}
