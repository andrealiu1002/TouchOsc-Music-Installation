from mmm_python import *

mmm_audio = MMMAudio(256, graph_name="FM_02_03", package_name="user_files")
mmm_audio.start_audio()

osc_handlers = {
 "/fader1": lambda args: (
        mmm_audio.send_float("mod_mul", args[0] * 2000.0)
    ),
    "/fader2": lambda args: print("fader2", args),
    "/button1": lambda args: (
        mmm_audio.send_float("button1", args[0])
    ),

    "/xy1": lambda args: (
        mmm_audio.send_float("freq_car", linexp(args[0], 0.0, 1.0, 100.0, 5000.0)),
        mmm_audio.send_float("freq_mod", linexp(args[1], 0.0, 1.0, 100.0, 2300.0))
    )
}

def osc_msg_handler(key, *args):
    print(f"Received OSC message: {key} with arguments: {args}")
    if key in osc_handlers:
        osc_handlers[key](args)

osc_server = OSCServer("0.0.0.0", 5005, osc_msg_handler)
osc_server.start()