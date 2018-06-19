# -------------------
# envset + other init
# -------------------

#echo -e "\n" && neofetch && echo -e "\n"

export DUNGEON="$HOME/dungeon"
# export OCIO="$DUNGEON/ocio/spi-anim/config.ocio"
export OCIO="$DUNGEON/ocio/aces_1.0.3/config.ocio"
# export PROJECTS="$HOME/projects"

if [[ `uname` == 'Darwin' ]]; then

    export PATH=$PATH:~/bin:/Applications/ChaosGroup/V-Ray/Maya2018/bin:/Applications/Autodesk/maya2018/Maya.app/Contents/bin
    # source /Users/Shared/rlm/rlmenvset.sh

    # set env for apps launched via launchpad, spotlight, and dock
    launchctl setenv LIBRARY $DUNGEON
    launchctl setenv OCIO $OCIO
    launchctl setenv PATH $PATH

    # houdini config
    if [ -d "/Applications/Houdini/Current/Frameworks/Houdini.framework/Versions/Current/Resources/" ]; then
        cd /Applications/Houdini/Current/Frameworks/Houdini.framework/Versions/Current/Resources/
        . ./houdini_setup
        cd
    fi

elif [[ `uname` == 'Linux' ]]; then

    if [ -z $(echo $PATH | grep $HOME/bin) ]; then
        export PATH=$PATH:$HOME/bin
    fi

    if [ -z $(echo $PATH | grep $HOME/.local/bin) ]; then
        export PATH=$PATH:$HOME/.local/bin
    fi

    if [ -z "$(hostname | grep stellar)" ]; then
        # maya
        export MAYA_AUTOSAVE_FOLDER="/var/tmp/maya_auto"

        # yeti
        export YETI_TMP="/var/tmp/yeti"
        export YETI_HOME="/opt/yeti"
        export RMAN_PROCEDURALS_PATH="/opt/yeti/bin" # for renderman
        export REDSHIFT_MAYAEXTENSIONSPATH="/opt/yeti/plug-ins"

        # nuke
        TNT_NUKE_ICONS="$DUNGEON/nuke/scripts/tnt_nuke/icons"
        CRYPTOMATTE="$DUNGEON/nuke/plugins/Cryptomatte"
        PGBOKEH="$DUNGEON/nuke/plugins/pgBokeh"
        VDENOISE_NUKE="$DUNGEON/nuke/plugins/VRayDenoiser"
        export NUKE_PATH=$TNT_NUKE_ICONS:$CRYPTOMATTE:$PGBOKEH:$VDENOISE_NUKE

        export NUKE_TEMP_DIR="/var/tmp/nuke"
        export NUKE_DISK_CACHE="/var/tmp/nuke/viewer"
        export NUKE_DISK_CACHE_GB=2

        # maya path
        export PATH=$PATH:/usr/autodesk/maya2018/bin
        # mari
        # export MARI_COLORSPACE_USER_INTERFACE_MODE=2 #advanced color space options
        # export MARI_SCRIPT_PATH= <list of mari script paths>

        # renderman
        # export RMSTREE=/opt/pixar/RenderManForMaya-21.3-maya2017
        # export RMANTREE=/opt/pixar/RenderManProServer-21.3
        # export MAYA_RENDER_DESC_PATH=$RMSTREE/etc/rmanRenderer.xml #for command line renders
        # export PATH=$PATH:$RMANTREE/bin #:/usr/ChaosGroup/V-Ray/Maya2017-x64/bin

        # arnold
        # export PATH=$PATH:/opt/solidangle/mtoa/2017/bin #for maketx

        # al shaders
        export ALSHADERS_INSTALL="/opt/alShaders"
        export ARNOLD_PLUGIN_PATH=$ALSHADERS_INSTALL/bin
        export MTOA_TEMPLATES_PATH=$ALSHADERS_INSTALL/ae
        export MAYA_CUSTOM_TEMPLATE_PATH=$ALSHADERS_INSTALL/aexml

        # redshift ONLY SETTING FOR HOUDINI. these are taken care of for maya with the .mod
        export REDSHIFT_COREDATAPATH="/opt/redshift_experimental"
        export REDSHIFT_LOCALDATAPATH="$HOME/redshift"
        export REDSHIFT_PREFSPATH="$HOME/redshift/preferences.xml"
        export REDSHIFT_LICENSEPATH="$HOME/redshift"

        # vray
        export PATH=$PATH:/usr/ChaosGroup/V-Ray/Maya2018-x64/bin
        export VRAY_VFB_SRGB=2 #off
        #export VRAY_VFB_SRGB=1 #on
        #export VRAY_VFB_OCIO=2 #off
        export VRAY_VFB_OCIO=1 #on

	# initialize houdini env
	if [ -d "/opt/hfs" ]; then
		cd /opt/hfs/
		. ./houdini_setup &> /dev/null
		cd ~
	fi

    fi

    # transparent blur konsole if KDE
    if [ ! -z $XDG_SESSION_DESKTOP ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then #only blur konsole if local session
        konsolex=$(qdbus | grep konsole | cut -f 2 -d\ )
        if [ -n "$konsolex" ]; then
            for konsole in `xdotool search --class konsole`; do
                xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $konsole;
            done
        fi
    fi
fi
