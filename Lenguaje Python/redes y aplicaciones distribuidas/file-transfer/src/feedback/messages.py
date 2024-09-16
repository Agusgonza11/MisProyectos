from abc import ABC
from enum import Enum


class Message(ABC):
    def __init__(self):
        """Subclass responsibility"""
        pass

    def is_upload(self):
        return False

    def is_download(self):
        return False


class UploadMessage(Message):
    def __init__(self, path, name, data):
        self.path = path
        self.name = name
        self.message = data

    def is_upload(self):
        return True
    
    def full_path(self):
        return self.path + "/" + self.name


class DownloadMessage(Message):
    def __init__(self, file_path):
        self.file_path = file_path

    def is_download(self):
        return True

    def full_path(self):
        return self.file_path