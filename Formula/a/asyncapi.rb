class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.7.3.tgz"
  sha256 "7f713ca3e25d3677f2f5fb28a136d7b5fca45facc8eecc1cc61cbc870e9232e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6056182d6141846e602b58ce8ad0daa244cc944089652646c95373c3dd7ad58"
    sha256 cellar: :any,                 arm64_sonoma:  "e6056182d6141846e602b58ce8ad0daa244cc944089652646c95373c3dd7ad58"
    sha256 cellar: :any,                 arm64_ventura: "e6056182d6141846e602b58ce8ad0daa244cc944089652646c95373c3dd7ad58"
    sha256 cellar: :any,                 sonoma:        "c03398ebb31b375532c8fc67458569f9ffa467797b92aaea961a379190903e1f"
    sha256 cellar: :any,                 ventura:       "c03398ebb31b375532c8fc67458569f9ffa467797b92aaea961a379190903e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "811155a4c3512096408fc800c12425299f45fea0a50bfe16b1e387d5e4661c91"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
