//Defining pollution as global variables
final int factoryPollution = 10;
final int farmPollution = 12;
final int housePollution = 6;
final int forestPollution = -2;
final int dirtPollution = 0;

int getPollution(LandUse lu) {
  /*Returns the default pollution value of each landUse
  *This method is used to set the default pollution values when game is initialized*/
  if (lu instanceof Factory) return factoryPollution;
  else if (lu instanceof Farm) return farmPollution;
  else if (lu instanceof House) return housePollution;
  else if (lu instanceof Forest) return forestPollution;
  else if (lu instanceof Dirt) return dirtPollution;
  else return 0;
}