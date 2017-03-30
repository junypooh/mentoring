package kr.or.career.mentor.util;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.List;

@Slf4j
public class CompressionUtils {

    public static void zip(CompressionFile[] compressionFiles, OutputStream os) {
        zip(Arrays.asList(compressionFiles), os);
    }

    public static void zip(List<CompressionFile> compressionFiles, OutputStream os) {
        try (ZipArchiveOutputStream zos = new ZipArchiveOutputStream(os)) {
            //zos.setEncoding(Charset.defaultCharset().displayName());
            zos.setEncoding("UTF-8");

            byte[] buf = new byte[8 * 1024];
            int offset = 0;
            for (CompressionFile compressionFile : compressionFiles) {
                log.debug("[request] compressionFile: {}", compressionFile);

                File file = new File(compressionFile.getFilepath(), compressionFile.getFilename());
                if (!file.exists()) {
                    continue;
                }
                FileInputStream fis = new FileInputStream(file);
                ZipArchiveEntry zae = new ZipArchiveEntry(compressionFile.getOrgFilename());
                zos.putArchiveEntry(zae);
                while ((offset = fis.read(buf, 0, buf.length)) >= 0) {
                    zos.write(buf, 0, offset);
                }
                fis.close();
                zos.closeArchiveEntry();
            }
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


}
