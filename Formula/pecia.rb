# Homebrew formula for the eyuppastirmaci/pecia tap, rendered by the release workflow for each version.
class Pecia < Formula
  desc "Offline lexical and semantic search for documents and source code"
  homepage "https://github.com/eyuppastirmaci/pecia"
  version "0.1.0-rc.1"
  license "MIT"

  on_macos do
    # ONNX Runtime has no Intel macOS build, so only Apple silicon has a package.
    depends_on arch: :arm64

    url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.0-rc.1/pecia-0.1.0-rc.1-osx-aarch64.tar.gz"
    sha256 "7dfb31870b08eced09112fd09498eb4bbe731a08d030b60ade120d34a37642b1"
  end

  on_linux do
    on_intel do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.0-rc.1/pecia-0.1.0-rc.1-linux-x64.tar.gz"
      sha256 "2fd77c2dc08c5a33e6cba6bff7d39f89041c3b28435eba38f8153e7e5ffeb290"
    end

    on_arm do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.0-rc.1/pecia-0.1.0-rc.1-linux-aarch64.tar.gz"
      sha256 "bf97cc332707388c307bc5c3ba4d089d8d524fe856076abe37d476da6791d833"
    end
  end

  def install
    # The package bundles its own Java runtime; its launcher finds it through this link.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/pecia"
  end

  test do
    assert_match "pecia #{version}", shell_output("#{bin}/pecia --version")

    (testpath/"refunds.md").write "# Refunds\n\nMoney goes back to the original card.\n"
    system bin/"pecia", "init"
    system bin/"pecia", "index", "--progress=none"
    assert_match "refunds.md", shell_output("#{bin}/pecia query refunds")
  end
end
