import React from 'react';
import {Button, Text, View} from 'react-native';
import { checkUpdate, installPackage, restartApp, clearUpdates } from 'react-native-ota-update';

const UpdateScreen = () => {

  const [packages, setPackages] = React.useState<any | undefined>();
  const [log, setLog] = React.useState<string>('');

  const options = {
    serverURL: "https://developbranch.cn/release/example-jsbundle"
  };

  const types = ["release"];

  function downloadProgressCallback(progress: any) {
    //console.log('progress', progress);
    setLog(JSON.stringify(progress));
  }

  return (
    <View>
      <Button 
        title="Check for Update" 
        onPress={() => {
          checkUpdate(options, types)
          .then((packages: any[]) => {
            console.log("check for update", packages);
            setPackages(packages);
            setLog('Packages: ' + packages.length);
          });
        }}
      />
      {packages && (
        <View>
          <Text>Choose a package:</Text>
          {packages.map((pkg: any) => {
            return (
              <Button
                title={pkg.version}
                onPress={() => {
                  console.log('select package', pkg);
                  installPackage(pkg).then(() => setLog("Installed jsbundle"));
                }}
                key={pkg.version}
              />
            );
          })}
        </View>
      )}
      <Text>{log}</Text>
      <Button 
        title="Clear Updates" 
        onPress={() => {
          console.log('clear update');
          clearUpdates().then(() => setLog("Clear updates"));
        }}
      />
      <Button 
        title="Restart App" 
        onPress={() => {
          console.log('Restart app');
          restartApp().then(() => setLog("Restart app"));
        }}
      />
    </View>
  )
};

export default UpdateScreen;