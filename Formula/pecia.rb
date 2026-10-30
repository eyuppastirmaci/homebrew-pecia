# Homebrew formula for the eyuppastirmaci/pecia tap, rendered by the release workflow for each version.
class Pecia < Formula
  desc "Offline lexical and semantic search for documents and source code"
  homepage "https://github.com/eyuppastirmaci/pecia"
  license "MIT"

  on_macos do
    # ONNX Runtime has no Intel macOS build, so only Apple silicon has a package.
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.0/pecia-0.1.0-osx-aarch64.tar.gz"
      sha256 "64c87b779503f3c0bf863c9afcb2678861c697fbe8f0fe6db0f7f18b73ae05e0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.0/pecia-0.1.0-linux-x64.tar.gz"
      sha256 "1e26ac1a7058b024725b0ba3c4062b1c861533df4293003322e59d83dda92ecc"
    end

    on_arm do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.0/pecia-0.1.0-linux-aarch64.tar.gz"
      sha256 "79a371deed2b608b4872718e20403f733415cdf6af4a9c992da0b1e0209b49da"
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
