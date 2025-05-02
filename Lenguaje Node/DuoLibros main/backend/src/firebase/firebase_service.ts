import { Injectable } from '@nestjs/common';
import { getStorage } from 'firebase-admin/storage';
import { join } from 'node:path';

@Injectable()
export class FirebaseService {
  async uploadFile(
    file: Express.Multer.File,
    filename: string,
  ): Promise<string> {
    const storage = getStorage();

    const bucket = storage.bucket(process.env.FIREBASE_STORAGE_BUCKET);
    console.log(`${Date.now()}_${filename}`);

    const filePath = join('book-covers', `${Date.now()}_${filename}`);
    const fileUpload = bucket.file(filePath);

    // Upload file buffer to Firebase
    await fileUpload.save(file.buffer, {
      metadata: {
        contentType: file.mimetype,
      },
    });

    await fileUpload.makePublic();

    return fileUpload.publicUrl();
  }
}
