{ config, pkgs, ... }:

{
  # ── Kernel sysctl tweaks ─────────────────────────────────────────────────────

  boot.kernel.sysctl = {

    # ── Memory management ───────────────────────────────────────
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_bytes" = 4294967296;
    "vm.dirty_background_bytes" = 1073741824;
    "vm.dirty_expire_centisecs" = 3000;
    "vm.dirty_writeback_centisecs" = 1500;
    "vm.max_map_count" = 2147483642;

    # ── CPU / scheduler ─────────────────────────────────────────
    "kernel.sched_migration_cost_ns" = 500000;
    "kernel.sched_child_runs_first" = 1;

    # ── Network ─────────────────────────────────────────────────
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.ipv4.tcp_fastopen" = 3;

    # ── File system ─────────────────────────────────────────────
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;
  };

  # ── I/O scheduler ────────────────────────────────────────────────────────────
  services.udev.extraRules = ''
    # NVMe drives
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
    # SATA SSDs
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
    # HDDs
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

    # ── AMDGPU power level ───────────────────────────────────────
    ACTION=="bind", KERNEL=="card*", SUBSYSTEM=="drm", DRIVERS=="amdgpu", \
      ATTR{device/power_dri_level}="high"
  '';

  # ── CPU governor ─────────────────────────────────────────────────────────────
  powerManagement.cpuFreqGovernor = "performance";

  # ── Transparent Huge Pages ───────────────────────────────────────────────────
  boot.kernelParams = [ "transparent_hugepage=madvise" ];

  # ── Zram swap ────────────────────────────────────────────────────────────────
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # ── OOM killer ───────────────────────────────────────────────────────────────
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };

  # ── SSD trim ─────────────────────────────────────────────────────────────────
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # ── Nix build performance ────────────────────────────────────────────────────
  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0;
}
