class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "2f666eb901a9e0ec0155fe724876008cae94c542939c5ae989bbd8dcad93949b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b6ad7175592178cd9da91e6eb975406a22503a461a7be568cfcd36395a8f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aded32dad864830b9d2b7db4afecbf5341c855c493736fc4d520f49d79cc7867"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "215bfc89fc5c4340e95824b89c16dd71a71a2af254ac9c387b75c0438c572c04"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ade41f100b6da79f893eaa540d4e3f5495f3634849122a83e8dc681ded0c759"
    sha256 cellar: :any_skip_relocation, ventura:       "c91feb31bcd9d61e972275ce7c94c0cf624d861aa910756f5029379004ba6dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25deaf9effa68fc5eaba34fb7c2f5bd6eca39812f5e1098aa0714f6cf39ee55"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  # dotnet sdk version requirement patch, upstream pr ref, https://github.com/cake-build/cake/pull/4377
  patch do
    url "https://github.com/cake-build/cake/commit/92193becffb09dce10fda010a0de03f941919739.patch?full_index=1"
    sha256 "257220fb97858bd80c561be5d342c33eb21709cc76efefe9f8a0a3703e1cc329"
  end

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      /p:Version=#{version}
    ]

    system "dotnet", "publish", "src/Cake", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"cake").write_env_script libexec/"Cake", env
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
