import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';

export class Permission {
  // 请求用户授权
  static async requestPermissions(permissions: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager()
    const ctx = getContext()
    if (ctx) {
      const result = await atManager.requestPermissionsFromUser(ctx, permissions)
      return result.authResults.every(result => result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    }
    return false
  }

  // 打开权限设置 beta3
  static async openPermissionSetting(permissions: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager()
    const ctx = getContext()
    if (ctx) {
      const authResults = await atManager.requestPermissionOnSetting(ctx, permissions)
      return authResults.every(result => result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    }
    return false
  }
}

export const permission = new Permission()
