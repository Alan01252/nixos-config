self: super:
{
  # myGns3 = super.callPackage ./gns3 {};
  dotnetLatest = super.callPackage ./dotnet {};
  azureDataStudioLatest = super.callPackage ./azuredatastudio {};
}
