{ config, pkgs, ... }:

{ 
  environment.etc = {
    # Creates /etc/nanorc
    snapraid.source = /etc/snapraid.conf;
    snapraid.conf = {
        text = ''
            # Defines the file to use as parity storage
            # It must NOT be in a data disk
            # Format: "parity FILE_PATH"
            parity /mnt/parity/snapraid.parity
            
            # Defines the files to use as content list
            # You can use multiple specification to store more copies
            # You must have least one copy for each parity file plus one. Some more don't
            # hurt
            # They can be in the disks used for data, parity or boot,
            # but each file must be in a different disk
            # Format: "content FILE_PATH"
            content /var/snapraid.content
            content /mnt/data1/.snapraid.content
            content /mnt/data2/.snapraid.content
            content /mnt/data3/.snapraid.content
            
            # Defines the data disks to use
            # The order is relevant for parity, do not change it
            # Format: "disk DISK_NAME DISK_MOUNT_POINT"
            data d1 /mnt/data1
            data d2 /mnt/data2
            data d3 /mnt/data3

            # Excludes hidden files and directories (uncomment to enable).
            #nohidden
            
            include /movies/
            include /tv/
            include /torrent/completed
            
            # Defines files and directories to exclude
            # Remember that all the paths are relative at the mount points
            # Format: "exclude FILE"
            # Format: "exclude DIR/"
            # Format: "exclude /PATH/FILE"
            # Format: "exclude /PATH/DIR/"
            exclude /tmp/
            exclude /lost+found/
            exclude appdata/
            exclude /.snapshots/
            exclude *.unrecoverable
            exclude *.!sync
            exclude *.tmp
        '';

        # The UNIX file mode bits
        mode = "0644";
    };
  };
}