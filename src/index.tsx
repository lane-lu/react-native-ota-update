import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-ota-update' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const OtaUpdate = NativeModules.OtaUpdate
  ? NativeModules.OtaUpdate
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return OtaUpdate.multiply(a, b);
}

export function checkUpdate(options: any, types: string[]): Promise<any> {
  return OtaUpdate.checkUpdate(options, types);
}

export function installPackage(package_: any): Promise<any> {
  return OtaUpdate.installPackage(package_);
}

export function getConfiguration(): Promise<any> {
  return OtaUpdate.getConfiguration();
}

export function restartApp(): Promise<any> {
  return OtaUpdate.restartApp();
}

export function clearUpdates(): Promise<any> {
  return OtaUpdate.clearUpdates();
}