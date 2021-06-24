package com.tuchuang.upload;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.util.List;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;

import java.sql.*;

/**
 * Servlet implementation class UploadServlet
 */

// ��������� web.xml ������ʹ������Ĵ���
@WebServlet("/upload")
public class UploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// �ϴ��ļ��洢Ŀ¼
	private static final String ORIGIN_DIRECTORY = "origin";
	private static final String SAMPLE_DIRECTORY = "sample";

	// �ϴ�����
	private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

	private static final char[] HEX_ARRAY = "0123456789ABCDEF".toCharArray();

	public static String bytesToHex(byte[] bytes) {
		char[] hexChars = new char[bytes.length * 2];
		for (int j = 0; j < bytes.length; j++) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = HEX_ARRAY[v >>> 4];
			hexChars[j * 2 + 1] = HEX_ARRAY[v & 0x0F];
		}
		return new String(hexChars);
	}

	private static String getSha1(InputStream fis) throws Exception {
		MessageDigest digest = MessageDigest.getInstance("SHA-1");
		int n = 0;
		byte[] buffer = new byte[8192];
		while (n != -1) {
			n = fis.read(buffer);
			if (n > 0) {
				digest.update(buffer, 0, n);
			}
		}
		return bytesToHex(digest.digest());
	}

	private String getRealPath(String path) {
		return getServletContext().getRealPath("/") + File.separator + path;
	}

	private Connection getConnection() throws ClassNotFoundException, SQLException {
		Connection c = null;
		String connectString = "jdbc:mysql://web.malloc.fun:3306/web_malloc_fun" + "?autoReconnect=true&useUnicode=true"
				+ "&characterEncoding=UTF-8";
		String user = "web_malloc_fun";
		String pwd = "y7tM7hftsFSyMC2y";
		Class.forName("com.mysql.jdbc.Driver");
		c = DriverManager.getConnection(connectString, user, pwd);
		return c;
	}

	private void createIfNotExists(String path) {
		File uploadDir = new File(path);
		if (!uploadDir.exists()) {
			uploadDir.mkdir();
		}
	}

	public void init() throws ServletException {
		createIfNotExists(getRealPath(ORIGIN_DIRECTORY));
		createIfNotExists(getRealPath(SAMPLE_DIRECTORY));

		Connection c = null;
		Statement stmt = null;
		try {
			c = getConnection();
			System.out.println("Opened database successfully");

			stmt = c.createStatement();
			String sql = "CREATE TABLE IF NOT EXISTS IMAGE (\n"
					+ "    ID         INTEGER   PRIMARY KEY AUTO_INCREMENT\n" 
					+ "                         NOT NULL,\n"
					+ "    SHA1       CHAR (40) NOT NULL,\n" 
					+ "    Token      CHAR (40) NOT NULL,\n"
					+ "    Path       TEXT   NOT NULL,\n" 
					+ "    UserId     INTEGER   NOT NULL,\n"
					+ "    CreateTime DATE      NOT NULL\n" 
					+ ");";
			stmt.executeUpdate(sql);
			stmt.close();
			c.close();
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
		}
	}

	public static String getRandomString(int length){
	    String str="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	    Random random=new Random();
	    StringBuffer sb=new StringBuffer();
	    for(int i=0;i<length;i++){
	      int number=random.nextInt(62);
	      sb.append(str.charAt(number));
	    }
	    return sb.toString();
	}
	
	private boolean insertIntoDatabase(int userId, String sha1, String path) {
		Connection c = null;
		Statement stmt = null;
		
		try {
			c = getConnection();
			stmt = c.createStatement();
			String querySql = "SELECT Id FROM IMAGE WHERE userId = " + userId + " and sha1 = '" + sha1 + "';";
			System.out.println(querySql);
			ResultSet rs = stmt.executeQuery(querySql);
			boolean isNotEmpty = rs.next();
			System.out.println(isNotEmpty);
			if(isNotEmpty) return false;
			
			String token = getRandomString(40);
			System.out.println(token);
			String insertSql = "INSERT INTO IMAGE VALUES(NULL, '" + sha1 + "', '" + token + "', '" + path + "', " + userId + ", " + "now() )";
			// System.out.println(insertSql);
			int res = stmt.executeUpdate(insertSql);
			return res != 0;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}  finally {
			// �ر���Դ
			try {
				if (stmt != null)
					stmt.close();
			} catch (SQLException se2) {
			} // ʲô������
			try {
				if (c != null)
					c.close();
			} catch (SQLException se) {
				se.printStackTrace();
			}
		}
	}

	private String insertImage(int userId, FileItem item) throws Exception {
		InputStream input = item.getInputStream();
		ImageIO.read(input);
		input.close();
		input = item.getInputStream();
		String sha1 = getSha1(input);
		input.close();
		System.out.println(sha1);
		// It's an image (only BMP, GIF, JPG and PNG are recognized).
		String extension = FilenameUtils.getExtension(item.getName());
		String uploadPath = ORIGIN_DIRECTORY + "/" + String.valueOf(userId);
		createIfNotExists(getRealPath(uploadPath));
		String filePath = uploadPath + "/" + sha1 + "." + extension;
		if (insertIntoDatabase(userId, sha1, filePath)) {
			File storeFile = new File(getRealPath(filePath));
			if(storeFile.exists()) storeFile.delete();
			// �ڿ���̨����ļ����ϴ�·��
			System.out.println(storeFile.getAbsolutePath());
			// �����ļ���Ӳ��
			item.write(storeFile);
		}
		return "./" + filePath;
	}

	/**
	 * �ϴ����ݼ������ļ�
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		Object userIdString = session.getAttribute("userId");
		if (userIdString == null)
			return;
		int userId = (int) userIdString;

		// ����Ƿ�Ϊ��ý���ϴ�
		if (!ServletFileUpload.isMultipartContent(request)) {
			// ���������ֹͣ
			PrintWriter writer = response.getWriter();
			writer.println("Error: ��������� enctype=multipart/form-data");
			writer.flush();
			return;
		}

		// �����ϴ�����
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// �����ڴ��ٽ�ֵ - �����󽫲�����ʱ�ļ����洢����ʱĿ¼��
		factory.setSizeThreshold(MEMORY_THRESHOLD);
		// ������ʱ�洢Ŀ¼
		factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

		ServletFileUpload upload = new ServletFileUpload(factory);

		// ��������ļ��ϴ�ֵ
		upload.setFileSizeMax(MAX_FILE_SIZE);

		// �����������ֵ (�����ļ��ͱ�����)
		upload.setSizeMax(MAX_REQUEST_SIZE);

		// ���Ĵ���
		upload.setHeaderEncoding("UTF-8");

		// ������ʱ·�����洢�ϴ����ļ�
		// ���·����Ե�ǰӦ�õ�Ŀ¼

		try {
			// ���������������ȡ�ļ�����
			@SuppressWarnings("unchecked")
			List<FileItem> formItems = upload.parseRequest(request);

			if (formItems != null && formItems.size() > 0) {
				// ����������
				for (FileItem item : formItems) {
					if (!item.isFormField()) {
						try {
							String url = insertImage(userId, item);
							request.setAttribute("message", "�ļ��ϴ��ɹ�!");
							request.setAttribute("url", url);
						} catch (Exception e) {
							request.setAttribute("message", "������Ϣ: " + e.getMessage());
						}
					}
				}
			}
		} catch (Exception ex) {
			request.setAttribute("message", "������Ϣ: " + ex.getMessage());
		}
		// ��ת�� message.jsp
		getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
	}
}