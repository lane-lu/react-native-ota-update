import React from 'react';
import {Text, View, Image} from 'react-native';

const ProfileScreen = () => {
  return (
    <View>
      <Image source={require('../picture/yellow.jpg')} />
      <Text>
        In the town where I was born
        Lived a man who sailed to sea
        And he told us of his life
        In the land of submarines
      </Text>
    </View>
  );
};

export default ProfileScreen;