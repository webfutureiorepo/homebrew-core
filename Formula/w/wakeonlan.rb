class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https://github.com/jpoliv/wakeonlan"
  url "https://github.com/jpoliv/wakeonlan/archive/refs/tags/v0.42.tar.gz"
  sha256 "4f533f109f7f4294f6452b73227e2ce4d2aa81091cf6ae1f4fa2f87bad04a031"
  license "Artistic-1.0-Perl"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c38012ee2876a996b157899c39255db1b15ff3775f1ce6e8af4726533cd2d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c38012ee2876a996b157899c39255db1b15ff3775f1ce6e8af4726533cd2d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65a0401b3ead62ae9434db4dce4244928aae7970d030f1a18fe713345d696b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c38012ee2876a996b157899c39255db1b15ff3775f1ce6e8af4726533cd2d1"
    sha256 cellar: :any_skip_relocation, ventura:       "65a0401b3ead62ae9434db4dce4244928aae7970d030f1a18fe713345d696b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e36175eff9d610ef9dea871b747a6e1b0414d3578b9ebc7ee9cecf0f9326d46"
  end

  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL"
    system "make"
    bin.install "blib/script/wakeonlan"
    man1.install "blib/man1/wakeonlan.1"
  end

  test do
    system bin/"wakeonlan", "--version"
  end
end
