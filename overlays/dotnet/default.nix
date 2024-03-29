/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_5_0 aspnetcore_5_0 ];

Hashes below are retrived from:
https://dotnet.microsoft.com/download/dotnet
*/
{ callPackage }:
let
  buildDotnet = attrs: callPackage (import ./build-dotnet.nix attrs) {};
  buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
  buildNetRuntime = attrs: buildDotnet (attrs // { type = "runtime"; });
  buildNetSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
in
rec {
  combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) {};

  # EOL

  sdk_2_1 = throw "Dotnet SDK 2.1 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";
  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";
  sdk_3_0 = throw "Dotnet SDK 3.0 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";

  # v3.1 (LTS)

  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.21";
    sha512 = {
      x86_64-linux = "f59252166dbfe11a78373226222d6a34484b9132e24283222aea8a950a5e9657da2e4d4e9ff8cbcc2fd7c7705e13bf42a31232a6012d1e247efc718e3d8e2df1";
      aarch64-linux = "f3d014431064362c29361e3d3b33b7aaaffe46e22f324cd42ba6fc6a6d5b712153e9ec82f10cf1bee416360a68fb4520dc9c0b0a8860316c4c9fce75f1adae80";
      x86_64-darwin = "477912671e21c7c61f5666323ad9e9c246550d40b4d127ccc71bcb296c86e07051e3c75251beef11806f198eebd0cd4b36790950f24c730dc6723156c0dc11b5";
    };
  };

  runtime_3_1 = buildNetRuntime {
    version = "3.1.21";
    sha512 = {
      x86_64-linux = "cc4b2fef46e94df88bf0fc11cb15439e79bd48da524561dffde80d3cd6db218133468ad2f6785803cf0c13f000d95ff71eb258cec76dd8eb809676ec1cb38fac";
      aarch64-linux = "80971125650a2fa0163e39a2de98bc2e871c295b723559e6081a3ab59d99195aa5b794450f8182c5eb4e7e472ca1c13340ef1cc8a5588114c494bbb5981f19c4";
      x86_64-darwin = "049257f680fe7dfb8e98a2ae4da6aa184f171b04b81c506e7a83509e46b1ea81ea6000c4d01c5bed46d5495328c6d9a0eeecbc0dc7c2c698296251fb04b5e855";
    };
  };

  sdk_3_1 = buildNetSdk {
    version = "3.1.415";
    sha512 = {
      x86_64-linux = "df7a6d1abed609c382799a8f69f129ec72ce68236b2faecf01aed4c957a40a9cfbbc9126381bf517dff3dbe0e488f1092188582701dd0fef09a68b8c5707c747";
      aarch64-linux = "7a5b9922988bcbde63d39f97e283ca1d373d5521cca0ab8946e2f86deaef6e21f00244228a0d5d8c38c2b9634b38bc7338b61984f0e12dd8fdb8b2e6eed5dd34";
      x86_64-darwin = "e26529714021d1828687c404dd0800c61eb267c9da62ee629b91f5ffa8af77d156911bd3c1a58bf11e5c589cfe4a852a95c14a7cb25f731e92a484348868964d";
    };
  };

  # v5.0 (Current)

  aspnetcore_5_0 = buildAspNetCore {
    version = "5.0.12";
    sha512 = {
      x86_64-linux = "0529f23ffa651ac2c2807b70d6e5034f6ae4c88204afdaaa76965ef604d6533f9440d68d9f2cdd3a9f2ca37e9140e6c61a9f9207d430c71140094c7d5c33bf79";
      aarch64-linux = "70570177896943613f0cddeb046ffccaafb1c8245c146383e45fbcfb27779c70dff1ab22c2b13a14bf096173c9279e0a386f61665106a3abb5f623b50281a652";
      x86_64-darwin = "bd9e7dd7f48c220121dde85b3acc4ce7eb2a1944d472f9340276718ef72d033f05fd9a62ffb9de93b8e7633843e731ff1cb5e8c836315f7571f519fdb0a119e1";
    };
  };

  runtime_5_0 = buildNetRuntime {
    version = "5.0.12";
    sha512 = {
      x86_64-linux = "32b5f86db3b1d4c21e3cf616d22f0e4a7374385dac0cf03cdebf3520dcf846460d9677ec1829a180920740a0237d64f6eaa2421d036a67f4fe9fb15d4f6b1db9";
      aarch64-linux = "a8089fad8d21a4b582aa6c3d7162d56a21fee697fd400f050a772f67c2ace5e4196d1c4261d3e861d6dc2e5439666f112c406104d6271e5ab60cda80ef2ffc64";
      x86_64-darwin = "a3160eaec15d0e2b62a4a2cdbb6663ef2e817fd26a3a3b8b3d75c5e3538b2947ff66eaddafb39cc297b9f087794d5fbd5a0e097ec8522ab6fea562f230055264";
    };
  };

  sdk_5_0 = buildNetSdk {
    version = "5.0.403";
    sha512 = {
      x86_64-linux = "7ba5f7f898dba64ea7027dc66184d60ac5ac35fabe750bd509711628442e098413878789fad5766be163fd2867cf22ef482a951e187cf629bbc6f54dd9293a4a";
      aarch64-linux = "6cc705fe45c0d8df6a493eb2923539ef5b62d048d5218859bf3af06fb3934c9c716c16f98ee1a28c818d77adff8430bf39a2ae54a59a1468b704b4ba192234ac";
      x86_64-darwin = "70beea069db182cca211cf04d7a80f3d6a3987d76cbd2bb60590ee76b93a4041b1b86ad91057cddbbaddd501c72327c1bc0a5fec630f38063f84bd60ba2b4792";
    };
  };

  # v6.0 (LTS)

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.1";
    sha512 = {
      x86_64-linux = "9e42c4ac282d3ed099203b9a8a06b4f1baf1267b4d51c9d505ca7127930534b60d4e94022036719133b30c1b503f66d7d4571bc24059d735e510f5e455ec6c51";
      aarch64-linux = "c1cab4bc800bd507ca6046ed1af900a7f1a7d28fa564615b8b93803139affc7f5fe6824c2b161ce635047862d644d724181424b44281b30a77f7159d6769c83c";
      x86_64-darwin = "e21cd7ead260038c820a2697d415d81ed9ce210e9d04e70ac87924f639cf5a37b2d8de400d0d3966fc6921100bb879e8d6fb9fcec9b67b02cecf180bc2f46865";
      aarch64-darwin = "ce6fab613172b07546f83885906c16eaf56b1de0744d326261222189466debd3ad901e95ff2916f51d7241321a31b2828f4b1fb6ce192224ebab2543dc652c64";
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.1";
    sha512 = {
      x86_64-linux = "2a316e8cba20778b409b8f2a3810348e2805f35afad8aba77a67c4e6bb2c2091e60bc369df22554bb145a5fad0c50e20b39d350b98a85bd33566034a11230da7";
      aarch64-linux = "10b8775d44088ddc1ae193ce41f456d1bbaad21f2dc993de75c2b076b6ffcb07bca446f52180c9a175715a1e47ad42a4862c43ef11b5cbc1023cb4da3c426146";
      x86_64-darwin = "45ed27f5cfd1674c4cb67a1242730928699608f6523a7fa7150c9a1b1e2ae972d32f7eae2fff119bccedfbfe1c7666ac8db882b442624157355e2f5e452b3900";
      aarch64-darwin = "35419a4340fbdd6e4ad15700a00687e163ee17234f7fd059df627db89efb47bb66a5194c96849ce65eb6fa2faaba5b5f7c53d0f169b3d8370e775ce865b745b8";
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.101";
    sha512 = {
      x86_64-linux = "ca21345400bcaceadad6327345f5364e858059cfcbc1759f05d7df7701fec26f1ead297b6928afa01e46db6f84e50770c673146a10b9ff71e4c7f7bc76fbf709";
      aarch64-linux = "04cd89279f412ae6b11170d1724c6ac42bb5d4fae8352020a1f28511086dd6d6af2106dd48ebe3b39d312a21ee8925115de51979687a9161819a3a29e270a954";
      x86_64-darwin = "36fde8f0cc339a01134b87158ab922de27bb3005446d764c3efd26ccb67f8c5acc16102a4ecef85a402f46bf4dfc9bdc28063806bb2b4a4faf0def13277a9268";
      aarch64-darwin = "af76f778e5195c38a4b6b72f999dc934869cd7f00bbb7654313000fbbd90c8ac13b362058fc45e08501319e25d5081a46d08d923ec53496d891444cf51640cf5";
    };
  };

}
