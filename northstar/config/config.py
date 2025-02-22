from dataclasses import dataclass
import numpy
import numpy.typing


@dataclass
class LocalConfig:
    device_id: str = "northstar1"
    server_ip: str = "10.66.47.2"
    stream_port: int = 8000
    has_calibration: bool = True
    camera_matrix: numpy.typing.NDArray[numpy.float64] = numpy.array([])
    distortion_coefficients: numpy.typing.NDArray[numpy.float64] = numpy.array([])


@dataclass
class RemoteConfig:
    camera_id: int = 0
    camera_resolution_width: int = 1600
    camera_resolution_height: int = 1200
    camera_auto_exposure: int = 1
    camera_exposure: int = 1
    camera_gain: int = 25
    fiducial_size_m: float = 0.1651
    tag_layout: any = ""
    tag_layout_name: any = "2025-reefscape.json"


@dataclass
class ConfigStore:
    local_config: LocalConfig
    remote_config: RemoteConfig
