//Defining pollution as global variables
final int factoryPollution = 20;
final int farmPollution = 12;
final int housePollution = 6;
final int forestPollution = -2;
final int dirtPollution = 0;

int getPollution(LandUse lu) {
  /*Returns the pollution value of the landUse on Tile t */
  if (lu instanceof Factory) return factoryPollution;
  else if (lu instanceof Farm) return farmPollution;
  else if (lu instanceof House) return housePollution;
  else if (lu instanceof Forest) return forestPollution;
  else if (lu instanceof Dirt) return dirtPollution;
  else return 0;
}