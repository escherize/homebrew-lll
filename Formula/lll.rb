# Homebrew formula template for lll. The release workflow
# (.github/workflows/release.yml) renders this on every v* tag: it replaces
# the __MARKERS__ below with the tag version and the sha256 of each release
# binary, then pushes the result to the tap repo (default
# escherize/homebrew-lll, override with TAP_REPO).
#
# Binary names here must match the artifacts the release workflow attaches:
# dist/lll-darwin-arm64, dist/lll-linux-amd64, dist/lll-linux-arm64.
#
# Until the tap repo exists and a TAP_TOKEN secret is set, the workflow skips
# the tap push and this template is the source of truth to copy by hand.

class Lll < Formula
  desc "Linear-style issue tracker that runs from a single binary"
  homepage "https://github.com/escherize/lll"
  version "1.4.1"

  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-darwin-arm64"
      sha256 "05c3a41bd172ebc54337b19513a766b219e63e031a07bf8b1d6623bafb36c40b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-amd64"
      sha256 "1bbcc64f9ff27ddad6abee41bf56bc2a99525e7a99ed43b3123dad4a79fc3a15"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-arm64"
      sha256 "7bd9c19eb4d01b0358e0b885c590a998bfef57c31522df74a6bd3c252f741a15"
    end
  end

  def install
    # Release assets are bare binaries named per platform; the staged file
    # keeps that name, so install renames it to lll. (Verified by a real
    # `brew install escherize/lll/lll` against the v0.2.0 tap.)
    if OS.mac?
      bin.install "lll-darwin-arm64" => "lll"
    elsif OS.linux? && Hardware::CPU.intel?
      bin.install "lll-linux-amd64" => "lll"
    else
      bin.install "lll-linux-arm64" => "lll"
    end
  end

  test do
    assert_match "lll #{version}", shell_output("#{bin}/lll --version")
  end
end
