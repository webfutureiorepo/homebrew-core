class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-0.19.0.tar.xz"
  sha256 "a1996347253c590de42f6e36e33bd1d5ec7479c0aa013769b92deef802df3c2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa91a41fa463bf8ac4cf37e5e902666009e66147e174be7a403d0902c53affa4" => :mojave
    sha256 "a99e236ed857f79a06465bd3a56e1d22dce9d5c70166b4ba34473fc42215601a" => :high_sierra
    sha256 "e7196c3102286cf5485c6f64a9b2275752f9e26b5dd44762a17d14c5df35195a" => :sierra
    sha256 "9b5f245d3eadef66260d0851c81c3f7a976768b98ace3aece7ce6e63eeb88345" => :el_capitan
  end

  head do
    url "https://github.com/nim-lang/Nim.git", :branch => "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        build_bin = buildpath/"bin"
        build_bin.install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimsuggest/nimble/nimgrep
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix
    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"

    target = prefix/"nim/bin"
    target.install "bin/nimsuggest"
    target.install "bin/nimble"
    target.install "bin/nimgrep"
    bin.install_symlink prefix/"nim/bin/nimsuggest"
    bin.install_symlink target/"nimble"
    bin.install_symlink target/"nimgrep"
  end

  test do
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
