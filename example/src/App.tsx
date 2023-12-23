import * as React from 'react';

import { Button, Text, TextInput, Switch } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';

import UpdateScreen from './update-screen';
import ProfileScreen from './profile-screen';
import { Screen } from 'react-native-screens';

type RootStackParamList = {
  'Home': undefined;
  'Update': undefined;
  'Profile': undefined;
};

type Props = NativeStackScreenProps<RootStackParamList>;

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function App() {

  React.useEffect(() => {
    console.log('React.useEffect');
  }, []);

  return (
    <>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen
            name="Home"
            component={HomeScreen}
            options={{ title: 'Welcome' }}
          />
          <Stack.Screen name="Update" component={UpdateScreen} />
          <Stack.Screen name="Profile" component={ProfileScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </>
  );
}

const HomeScreen = ({ navigation }: Props) => {
  return (
    <>
      <Button
        title="Update"
        onPress={() => navigation.navigate('Update')}
      />
      <Button
        title="Profile"
        onPress={() => navigation.navigate('Profile')}
      />
    </>
  );
};