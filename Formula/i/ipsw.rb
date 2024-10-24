class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.552.tar.gz"
  sha256 "473142a61a097017cb4d86078b4d47dba518b8ae3da93e7fae52c2e536300b97"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98a84125353b806050012540482595458398d0ac13dfb84937ebf31a0adfe7b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd25ebfee77183c1fe83e517647c67bd93012aa4972d4383ab79c2d726323ed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c6de1623dcff7f33f003f91111a638f1cf2ed0c30c8d4e2ba0e9be2ee50e80c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9532fba9a35ed7c755568551b02beec64724cd0717b80b1eb04f3e70792416"
    sha256 cellar: :any_skip_relocation, ventura:       "fd6f3b44a3bc30c9b2a81ef63860184678566197b7c790ba0b36adf595136511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c8e1cae888b99fb036f2436b44902579e1a5aca64efbccde2e36535d217d94"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
