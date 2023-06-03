from http.server import HTTPServer

from malware_detection.request_handler import MalwareDetectionAPI


MALWARE_DETECTION_API_PORT = 9087
MALWARE_DETECTION_SERVER_ADDRESS = ("localhost", MALWARE_DETECTION_API_PORT)


def run_malware_detection_server():
    httpd = HTTPServer(MALWARE_DETECTION_SERVER_ADDRESS, MalwareDetectionAPI)
    print(f"Starting server on at {MALWARE_DETECTION_SERVER_ADDRESS}")
    httpd.serve_forever()


if __name__ == "__main__":
    run_malware_detection_server()