/*
 Navicat Premium Data Transfer

 Source Server         : JAVA
 Source Server Type    : MySQL
 Source Server Version : 50717
 Source Host           : 127.0.0.1:3306
 Source Schema         : blog

 Target Server Type    : MySQL
 Target Server Version : 50717
 File Encoding         : 65001

 Date: 26/01/2021 12:45:22
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '文章标题',
  `content` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT '文章内容',
  `pubtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `date` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '存档时间',
  `brief` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT '简介',
  `tag_id` tinyint(11) NOT NULL COMMENT '分类id',
  `hits` int(11) NOT NULL DEFAULT 0 COMMENT '点击次数',
  `bad` int(11) NOT NULL DEFAULT 0 COMMENT '不好',
  `good` int(11) NOT NULL DEFAULT 0 COMMENT '点赞',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '文章logo',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (1, 'Java单例模式', '\n                    \n                    \n\n\n## 一、单例\n1、懒汉式  \n缺陷：在并发的情况之下会多次创建Singleton。  \n2、饿汉式  \n缺陷：在单例对象较大的情况之下没有使用也会随着JVM启动从而创建。  \n3、双检锁   \n双检锁所解决的问题：  \n1、（饿汉式缺陷）在需要的时候创建，而非JVM启动时就加载\n2、（懒汉式缺陷）解决并发的问题，同时解决了效率问题（双重检查加锁）和防止在创建对象时的指令重排（volatile ）\n\n## 二、一些不容忽略的问题  \n1、利用反射破坏单例模式  \n2、利用序列化与反序列化破坏单例模式  \n## 三、一些推荐的方式 \n1、枚举  \n2、静态内部类 \n\n## 四、反射序列化突破 \n\n\n\n\n--------------------------------------------------------------------------------\n###  一、单例\n\n1、懒汉式 \n\n    public class Singleton {\n    \n    private static Singleton singleton;\n    \n    private Singleton(){}\n    \n    public static Singleton getInstance() {\n        if (singleton == null) {\n        singleton = new Singleton();\n    }\n        return singleton;\n    }\n    \n    }\n\n\n缺陷：在并发的情况之下会多次创建Singleton。\n\n2、饿汉式  \n\n    public class Singleton{\n    \n    private static final Singleton singleton = new Singleton();\n    \n    private Singleton(){}\n    \n    public static Singleton getInstance() {\n    	return singleton;\n    }\n    }\n\n\n缺陷：在单例对象较大的情况之下没有使用也会随着JVM启动从而创建。\n\n3、双检锁  \n双检锁所解决的问题：  \n1、（饿汉式缺陷）在需要的时候创建，而非JVM启动时就加载  \n2、（懒汉式缺陷）解决并发的问题，同时解决了效率问题（双重检查加锁）和防止在创建对象时的指令重排（volatile ）\n\n    public class Singleton {\n    \n    private static volatile Singleton singleton;\n    \n    private Singleton(){}\n    \n    public static Singleton getInstance() {\n    	if (singleton == null) {  // 线程A和线程B同时看到singleton = null，如果不为null，则直接返回singleton\n    		synchronized(Singleton.class) { // 线程A或线程B获得该锁进行初始化\n    		if (singleton == null) { // 其中一个线程进入该分支，另外一个线程则不会进入该分支\n    			singleton = new Singleton();\n    			}\n    		}\n    	}\n    	return singleton;\n    }\n    \n    }\n\n\n\n\n二、一些不容忽略的问题  \n 1、利用反射破坏单例模式  \n\n    public static void main(String[] args) {\n    // 获取类的显式构造器\n    	Constructor<Singleton> construct = Singleton.class.getDeclaredConstructor();\n    // 可访问私有构造器\n    	construct.setAccessible(true); \n    	// 利用反射构造新对象\n    	Singleton obj1 = construct.newInstance(); \n    // 通过正常方式获取单例对象\n    	Singleton obj2 = Singleton.getInstance(); \n    	System.out.println(obj1 == obj2); // false\n    }\n\n\n 2、利用序列化与反序列化破坏单例模式  \n\n    public static void main(String[] args) {\n	    // 创建输出流\n	    ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(\"Singleton.file\"));\n	    // 将单例对象写到文件中\n	    oos.writeObject(Singleton.getInstance());\n	    // 从文件中读取单例对象\n	    File file = new File(\"Singleton.file\");\n	    ObjectInputStream ois =  new ObjectInputStream(new FileInputStream(file));\n	    Singleton newInstance = (Singleton) ois.readObject();\n	    // 判断是否是同一个对象\n	    System.out.println(newInstance == Singleton.getInstance()); // false\n    }\n\n\n\n\n三、一些推荐的方式  \n\n1、枚举  \n（1）防反射  \n\n    if ((clazz.getModifiers() & Modifier.ENUM) != 0)\n    throw new IllegalArgumentException(\"Cannot reflectively create enum objects\");\n（2）防反序列化 \n \n在读入 Singleton 对象时，每个枚举类型和枚举名字都是唯一的，所以在序列化时，仅仅只是对枚举的类型和变量名输出到文件中，在读入文件反序列化成对象时，使用 Enum 类的 valueOf(String name) 方法根据变量的名字查找对应的枚举对象。\n所以，在序列化和反序列化的过程中，只是写出和读入了枚举类型和名字，没有任何关于对象的操作。 \n\n    public enum Singleton {\n    INSTANCE;\n    \n    public void doSomething() {\n        System.out.println(\"这是枚举类型的单例模式！\");\n    }\n    }\n\n\n\n\n2、静态内部类\n\n    /**\n     * 描述： 静态内部类方式，可用\n     */\n    public class Singleton7 {\n    \n        private Singleton7() {\n        }\n    \n        private static class SingletonInstance {\n    \n            private static final Singleton7 INSTANCE = new Singleton7();\n        }\n    \n        public void sayHi() {\n            System.out.println(\"hello\");\n        }\n    \n    \n        public static Singleton7 getInstance() {\n            return SingletonInstance.INSTANCE;\n        }\n    \n    \n        // 防止反射获取多个对象的漏洞\n        private SingletonDemo2() {\n            if (null != SingletonClassInstance.instance)\n                throw new RuntimeException();\n            }\n         }\n         // 防止反序列化获取多个对象的漏洞\n         private Object readResolve() throws ObjectStreamException {\n             return SingletonClassInstance.instance;\n         }\n    \n    \n    \n        public static void main(String[] args) {\n            Singleton7.getInstance().sayHi();\n        }\n        }\n\n\n使用静态内部类的优点是：因为外部类对内部类的引用属于被动引用，不属于前面提到的三种必须进行初始化的情况，所以加载类本身并不需要同时加载内部类。在需要实例化该类是才触发内部类的加载以及本类的实例化，做到了延时加载（懒加载），节约内存。同时因为JVM会保证一个类的<cinit>()方法（初始化方法）执行时的线程安全，从而保证了实例在全局的唯一性。\n\n这个其实就是枚举类的根本实现，至于防反射和反序列化还需要研究研究\n\n\n\n四、反射序列化突破 \n\n1、实例化\n\n\n    private Singleton() {\n    	throw new RuntimeException(\"实例化异常\");\n    }\n\n2、序列化\n附录：对象序列化.note\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n                \n                ', '2021-01-21 01:52:15', '2021年01月', 'Java单例模式', 1, 10, 5, 8, '/images/Java.jpg');
INSERT INTO `article` VALUES (2, 'keepalived + nginx', '\n                    \n##一、环境说明\n\n##二、安装nginx\n\n##三、安装keepalived\n\n##四、启动nginx、keepalived\n\n##五、故障转移\n\n--------------------------------------------------------------------------------\nkeepalived的HA分为抢占模式和非抢占模式，抢占模式即MASTER从故障中恢复后，会将VIP从BACKUP节点中抢占过来。非抢占模式即MASTER恢复后不抢占BACKUP升级为MASTER后的VIP。\n\n\n##一、环境说明\n\n    CentOS 7（Minimal Install）  \n    [root@lzb22_100 keepalived]# cat /etc/redhat-release  \n    CentOS Linux release 7.6.1810 (Core)\n\n\n| VIP | IP | 主机名 | nginx端口 |\n|  ----  | ----  | ----  | ----  |\n| 192.168.22.99 | 192.168.22.100 | lzb22_100 | 80 |\n| 192.168.22.99 | 192.168.22.101 | lzb22_101 | 80 |\n \n\n二、安装nginx\n\n（1）gcc 安装\n安装 nginx 需要先将官网下载的源码进行编译，编译依赖 gcc 环境，如果没有 gcc 环境，则需要安装：\n  \n    yum install gcc-c++\n\n（2） PCRE pcre-devel 安装\nPCRE(Perl Compatible Regular Expressions) 是一个Perl库，包括 perl 兼容的正则表达式库。nginx 的 http 模块使用 pcre 来解析正则表达式，所以需要在 linux 上安装 pcre 库，pcre-devel 是使用 pcre 开发的一个二次开发库。nginx也需要此库。命令：\n  \n    yum install -y pcre pcre-devel\n\n（3）zlib 安装\nzlib 库提供了很多种压缩和解压缩的方式， nginx 使用 zlib 对 http 包的内容进行 gzip ，所以需要在 Centos 上安装 zlib 库。\n  \n    yum install -y zlib zlib-devel\n\n（4） OpenSSL 安装\nOpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供丰富的应用程序供测试或其它目的使用。\nnginx 不仅支持 http 协议，还支持 https（即在ssl协议上传输http），所以需要在 Centos 安装 OpenSSL 库。 \n  \n    yum install -y openssl openssl-devel\n\n\n官网下载 \nhttp://nginx.org/en/download.html\n\n\n解压  \n\n    tar -zxvf nginx-1.10.0.tar.gz\n    cd nginx-1.18.0\n    \n\n\n配置\n\n1.使用默认配置  \n./configure\n\n\n2.自定义配置（不推荐）  \n\n    ./configure \\\n    --prefix=/usr/local/nginx \\\n    --conf-path=/usr/local/nginx/conf/nginx.conf \\\n    --pid-path=/usr/local/nginx/conf/nginx.pid \\\n    --lock-path=/var/lock/nginx.lock \\\n    --error-log-path=/var/log/nginx/error.log \\\n    --http-log-path=/var/log/nginx/access.log \\\n    --with-http_gzip_static_module \\\n    --http-client-body-temp-path=/var/temp/nginx/client \\\n    --http-proxy-temp-path=/var/temp/nginx/proxy \\\n    --http-fastcgi-temp-path=/var/temp/nginx/fastcgi \\\n    --http-uwsgi-temp-path=/var/temp/nginx/uwsgi \\\n    --http-scgi-temp-path=/var/temp/nginx/scgi\n\n\n编译安装\n\n    make\n    make install\n\n\n\n开机自启动（未实践）\n\n    vi /etc/rc.local\n\n\n增加一行 /usr/local/nginx/sbin/nginx\n设置执行权限：\n\n    chmod 755 rc.local\n\n\n\n\n三、安装keepalived\n\n（1）使用yum命令安装\n    yum install keepalived –y\n\n\n（2）确定网卡\n\n    [root@lzb22_100 keepalived]# ip a\n    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000\n    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00\n    inet 127.0.0.1/8 scope host lo\n       valid_lft forever preferred_lft forever\n    inet6 ::1/128 scope host \n       valid_lft forever preferred_lft forever\n    2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000\n    link/ether 00:50:56:a3:c9:92 brd ff:ff:ff:ff:ff:ff\n    inet 192.168.22.100/24 brd 192.168.22.255 scope global noprefixroute ens192\n       valid_lft forever preferred_lft forever\n    inet 192.168.22.99/32 scope global ens192\n       valid_lft forever preferred_lft forever\n    inet6 fe80::250:56ff:fea3:c992/64 scope link noprefixroute \n       valid_lft forever preferred_lft forever\n    3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default \n    link/ether 02:42:b5:12:66:8c brd ff:ff:ff:ff:ff:ff\n    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0\n       valid_lft forever preferred_lft forever\n    inet6 fe80::42:b5ff:fe12:668c/64 scope link \n       valid_lft forever preferred_lft forever\n\n\n\n\n（3）修改/etc/keepalived/keepalived.conf  配置\n\n    global_defs {\n    notification_email {\n    acassen@firewall.loc\n    failover@firewall.loc\n    sysadmin@firewall.loc\n    }\n    notification_email_from Alexandre.Cassen@firewall.loc\n    smtp_server 192.168.17.129\n    smtp_connect_timeout 30\n    router_id LVS_DEVEL\n    }\n    vrrp_script chk_http_port {\n    script \"/opt/nginx/nginx_check.sh\"\n    interval 2 #（检测脚本执行的间隔）\n    weight 2\n    }\n    vrrp_instance VI_1 {\n    state BACKUP # 备份服务器上将 MASTER 改为 BACKUP\n    interface ens33 #网卡\n    virtual_router_id 51 # 主、备机的 virtual_router_id 必须相同\n    priority 90 # 主、备机取不同的优先级，主机值较大，备份机值较小\n    advert_int 1\n    authentication {\n    auth_type PASS\n    auth_pass 1111\n    }\n    virtual_ipaddress {\n     192.168.22.99 # VRRP H 虚拟地址\n    }\n    track_script {\n     chk_http_port # nginx存活状态检测脚本\n    }\n    }\n\n\n\n（4）脚本检测 nginx_check.sh\n\n    \n    #!/bin/bash\n    A=`ps -C nginx --no-header |wc -l`\n    if [ $A -eq 0 ];then\n    /opt/nginx/sbin/nginx\n    sleep 2\n    if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then\n    killall keepalived\n    fi\n    fi\n\n\n\n centos下\n如果出现: -bash: killall: command not found  \n\n    yum install psmisc -y \n\n\n\n四、启动nginx、keepalived \n\n    nginx：./nginx\n    keepalived：systemctl start keepalived.service\n\n\n五、故障转移\n\n\n\n\n当将keepalived停止后，vip则到了101\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n                ', '2021-01-21 18:13:29', '2021年01月', '使用keepalived + nginx 实现nginx高可用', 4, 11, 1, 7, '/images/nginx.jpg');
INSERT INTO `article` VALUES (3, 'reset三种模式区别和使用场景', '##模式区别：\r\n\r\n--hard：重置位置的同时，直接将 working Tree工作目录、 index 暂存区及 repository 都重置成目标Reset节点的內容,所以效果看起来等同于清空暂存区和工作区。\r\n\r\n--soft：重置位置的同时，保留working Tree工作目录和index暂存区的内容，只让repository中的内容和 reset 目标节点保持一致，因此原节点和reset节点之间的【差异变更集】会放入index暂存区中(Staged files)。所以效果看起来就是工作目录的内容不变，暂存区原有的内容也不变，只是原节点和Reset节点之间的所有差异都会放到暂存区中。\r\n\r\n--mixed（默认）：重置位置的同时，只保留Working Tree工作目录的內容，但会将 Index暂存区 和 Repository 中的內容更改和reset目标节点一致，因此原节点和Reset节点之间的【差异变更集】会放入Working Tree工作目录中。所以效果看起来就是原节点和Reset节点之间的所有差异都会放到工作目录中。\r\n\r\n\r\n## 使用场景:\r\n\r\n--hard： \r\n\r\n(1) 要放弃目前本地的所有改变時，即去掉所有add到暂存区的文件和工作区的文件，可以执行 git reset -hard HEAD 来强制恢复git管理的文件夹的內容及状态；\r\n\r\n(2) 真的想抛弃目标节点后的所有commit（可能觉得目标节点到原节点之间的commit提交都是错了，之前所有的commit有问题）。\r\n\r\n\r\n--soft：\r\n\r\n原节点和reset节点之间的【差异变更集】会放入index暂存区中(Staged files)，所以假如我们之前工作目录没有改过任何文件，也没add到暂存区，那么使用reset --soft后，我们可以直接执行 git commit 將 index暂存区中的內容提交至 repository 中。为什么要这样呢？这样做的使用场景是：假如我们想合并「当前节点」与「reset目标节点」之间不具太大意义的 commit 记录(可能是阶段性地频繁提交,就是开发一个功能的时候，改或者增加一个文件的时候就commit，这样做导致一个完整的功能可能会好多个commit点，这时假如你需要把这些commit整合成一个commit的时候)時，可以考虑使用reset --soft来让 commit 演进线图较为清晰。总而言之，可以使用--soft合并commit节点。\r\n\r\n--mixed（默认）：\r\n\r\n(1)使用完reset --mixed后，我們可以直接执行 git add 将這些改变果的文件內容加入 index 暂存区中，再执行 git commit 将 Index暂存区 中的內容提交至Repository中，这样一样可以达到合并commit节点的效果（与上面--soft合并commit节点差不多，只是多了git add添加到暂存区的操作;\r\n\r\n(2)移除所有Index暂存区中准备要提交的文件(Staged files)，我们可以执行 git reset HEAD 来 Unstage 所有已列入 Index暂存区 的待提交的文件。(有时候发现add错文件到暂存区，就可以使用命令)。\r\n\r\n(3)commit提交某些错误代码，或者没有必要的文件也被commit上去，不想再修改错误再commit（因为会留下一个错误commit点），可以回退到正确的commit点上，然后所有原节点和reset节点之间差异会返回工作目录，假如有个没必要的文件的话就可以直接删除了，再commit上去就OK了。', '2021-01-26 02:35:57', '2021年01月', 'reset三种模式区别和使用场景', 3, 2, 0, 0, '/images/git.jpg');
INSERT INTO `article` VALUES (4, 'proxy_pass 小细节', '## proxy_pass 小细节\r\n\r\n\r\n* [ 一、proxy_pass 末尾加 / ](#1)\r\n 	* [ 1.1、proxy_pass 带路径 ](#1.1)\r\n 	* [ 1.2、proxy_pass 不带路径 ](#1.2)\r\n\r\n* [二、proxy_pass 末尾无 /](#2)\r\n	* [2.1 proxy_pass 带路径](#2.1)\r\n	* [2.2 proxy_pass 不带路径](#2.2)\r\n\r\n------\r\n\r\n\r\n\r\n<h2 id=\"1\"> 一、proxy_pass 末尾加 /</h2>\r\n\r\n\r\n\r\n<h3 id=\"1.1\"> 1、proxy_pass 带路径 </h3>\r\n	  location /tomcat/ {\r\n	          proxy_pass http://localhost:8080/abc/; \r\n	  }\r\n\r\n\r\n求请路径:  http://47.100.221.125/tomcat/12321\r\n\r\nnginx日志路径：\r\n\r\n`\"http_request_uri\": \"/tomcat/12321\"`\r\n\r\n\r\ntomcat日志：\r\n\r\n`127.0.0.1 - - [25/Jan/2021:10:34:37 +0800] \"GET /abc/12321 HTTP/1.0\" 404 1081`\r\n\r\n\r\n<h3 id=\"1.2\"> 2、proxy_pass 不带路径 </h3>\r\n\r\n      location /tomcat/ {\r\n              proxy_pass http://localhost:8080/;\r\n      }\r\n\r\n\r\n请求路径：  http://47.100.221.125/tomcat/\r\n\r\n\r\nnginx日志路径：\r\n\r\n`\"http_request_uri\": \"/tomcat/\"`\r\n\r\n\r\ntomcat日志：\r\n\r\n`127.0.0.1 - - [25/Jan/2021:10:44:19 +0800] \"GET / HTTP/1.0\" 200 11435\r\n`\r\n\r\n\r\n----------\r\n<h2 id=\"2\"> 一、proxy_pass 末尾无 /</h2>\r\n\r\n<h3 id=\"2.1\"> 1、proxy_pass 带路径 </h3>\r\n\r\n\r\n	location /tomcat/ {\r\n	    proxy_pass http://localhost:8080/abc;\r\n    }\r\n\r\n请求路径：  http://47.100.221.125/tomcat/123321\r\n\r\n\r\nnginx日志路径：\r\n\r\n`\"http_request_uri\": \"/tomcat/123321\"`\r\n\r\ntomcat日志：\r\n`127.0.0.1 - - [25/Jan/2021:11:07:48 +0800] \"GET /abc123321 HTTP/1.0\" 404 1077`\r\n\r\n\r\n**结论：会被代理到http://47.100.221.125/abc123321 (proxy_pass替换请求url的ip和端口）**\r\n\r\n\r\n\r\n\r\n\r\n\r\n<h3 id=\"2.2\"> 2、proxy_pass 不带路径 </h3>\r\n\r\n\r\n	location /tomcat/ {\r\n	    proxy_pass http://localhost:8080;\r\n    }\r\n\r\n请求路径 \r\nhttp://47.100.221.125/tomcat/\r\n\r\nnginx日志路径：\r\n\r\n`\"http_request_uri\": \"/tomcat/\"`\r\n\r\ntomcat日志：\r\n`127.0.0.1 - - [25/Jan/2021:10:54:42 +0800] \"GET /tomcat/ HTTP/1.0\" 404 1079`\r\n\r\n\r\n**结论：会被代理到http://47.100.221.125/tomcat/ (proxy_pass替换请求url的ip和端口）**\r\n\r\n\r\n\r\n', '2021-01-26 02:40:51', '2021年01月', ' ', 4, 7, 0, 0, '/images/nginx.jpg');
INSERT INTO `article` VALUES (5, 'Docker常用命令', '\n# 1、Docker容器信息\n\n    ##查看docker容器版本\n    docker version\n    ##查看docker容器信息\n    docker info\n    ##查看docker容器帮助\n    docker --help\n\n# 2、镜像操作\n\n	##列出本地images\n	docker images\n	##含中间映像层\n	docker images -a\n	\n	##显示镜像摘要信息(DIGEST列)\n	docker images --digests\n	##显示镜像完整信息\n	docker images --no-trunc\n\n\n\n## 2.2、镜像搜索\n\n\n	##搜索仓库MySQL镜像\n	docker search mysql\n	## --filter=stars=600：只显示 starts>=600 的镜像\n	docker search --filter=stars=600 mysql\n	## --no-trunc 显示镜像完整 DESCRIPTION 描述\n	docker search --no-trunc mysql\n	## --automated ：只列出 AUTOMATED=OK 的镜像\n	docker search  --automated mysql\n\n\n##2.3、镜像下载\n\n	\n	##下载Redis官方最新镜像，相当于：docker pull redis:latest\n	docker pull redis\n	##下载仓库所有Redis镜像\n	docker pull -a redis\n	##下载私人仓库镜像\n	docker pull bitnami/redis\n\n\n## 2.4、镜像删除\n\n	##单个镜像删除，相当于：docker rmi redis:latest\n	docker rmi redis\n	##强制删除(针对基于镜像有运行的容器进程)\n	docker rmi -f redis\n	##多个镜像删除，不同镜像间以空格间隔\n	docker rmi -f redis tomcat nginx\n	##删除本地全部镜像\n	docker rmi -f $(docker images -q)\n\n## 2.5、镜像构建\n\n	##（1）编写dockerfile\n	cd /docker/dockerfile\n	vim mycentos\n	##（2）构建docker镜像\n	docker build -f /docker/dockerfile/mycentos -t mycentos:1.1\n\n\n# 3、容器操作\n\n\n## 3.1、容器启动\n\n\n	##新建并启动容器，参数：-i  以交互模式运行容器；-t  为容器重新分配一个伪输入终端；--name  为容器指定一个名称\n	docker run -i -t --name mycentos\n	##后台启动容器，参数：-d  已守护方式启动容器\n	docker run -d mycentos\n\n\n	##启动一个或多个已经被停止的容器\n	docker start redis\n	##重启容器\n	docker restart redis\n\n\n## 3.2、容器进程\n\n\n\n    ##top支持 ps 命令参数，格式：docker top [OPTIONS] CONTAINER [ps OPTIONS]\n    ##列出redis容器中运行进程\n    docker top redis\n    ##查看所有运行容器的进程信息\n    for i in  `docker ps |grep Up|awk \'{print $1}\'`;do echo \\ &&docker top $i; done\n\n\n## 3.3、容器日志\n\n\n    ##查看redis容器日志，默认参数\n    docker logs rabbitmq\n    ##查看redis容器日志，参数：-f  跟踪日志输出；-t   显示时间戳；--tail  仅列出最新N条容器日志；\n    docker logs -f -t --tail=20 redis\n    ##查看容器redis从2019年05月21日后的最新10条日志。\n    docker logs --since=\"2019-05-21\" --tail=10 redis\n\n\n## 3.4、容器的进入与退出\n\n\n    ##使用run方式在创建时进入\n    docker run -it centos /bin/bash\n    ##关闭容器并退出\n    exit\n    ##仅退出容器，不关闭\n    快捷键：Ctrl + P + Q\n    ##直接进入centos 容器启动命令的终端，不会启动新进程，多个attach连接共享容器屏幕，参数：--sig-proxy=false  确保CTRL-D或CTRL-C不会关闭容器\n    docker attach --sig-proxy=false centos \n    ##在 centos 容器中打开新的交互模式终端，可以启动新进程，参数：-i  即使没有附加也保持STDIN 打开；-t  分配一个伪终端\n    docker exec -i -t  centos /bin/bash\n    ##以交互模式在容器中执行命令，结果返回到当前终端屏幕\n    docker exec -i -t centos ls -l /tmp\n    ##以分离模式在容器中执行命令，程序后台运行，结果不会反馈到当前终端\n    docker exec -d centos  touch cache.txt\n\n\n## 3.5、查看容器\n\n\n    ##查看正在运行的容器\n    docker ps\n    ##查看正在运行的容器的ID\n    docker ps -q\n    ##查看正在运行+历史运行过的容器\n    docker ps -a\n    ##显示运行容器总文件大小\n    docker ps -s\n\n\n	##显示最近创建容器\n	docker ps -l\n	##显示最近创建的3个容器\n	docker ps -n 3\n	##不截断输出\n	docker ps --no-trunc \n	\n	##获取镜像redis的元信息\n	docker inspect redis\n	##获取正在运行的容器redis的 IP\n	docker inspect --format=\'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}\' redis\n\n\n\n ## 3.6、容器的停止与删除\n \n \n    ##停止一个运行中的容器\n    docker stop redis\n    ##杀掉一个运行中的容器\n    docker kill redis\n    ##删除一个已停止的容器\n    docker rm redis\n    ##删除一个运行中的容器\n    docker rm -f redis\n    ##删除多个容器\n    docker rm -f $(docker ps -a -q)\n    docker ps -a -q | xargs docker rm\n    ## -l 移除容器间的网络连接，连接名为 db\n    docker rm -l db \n    ## -v 删除容器，并删除容器挂载的数据卷\n    docker rm -v redis\n\n\n##  3.7、生成镜像\n\n\n    ##基于当前redis容器创建一个新的镜像；参数：-a 提交的镜像作者；-c 使用Dockerfile指令来创建镜像；-m :提交时的说明文字；-p :在commit时，将容器暂停\n    docker commit -a=\"DeepInThought\" -m=\"my redis\" [redis容器ID]  myredis:v1.1\n\n\n##  3.8、容器与主机间的数据拷贝\n\n    ##将rabbitmq容器中的文件copy至本地路径\n    docker cp rabbitmq:/[container_path] [local_path]\n    ##将主机文件copy至rabbitmq容器\n    docker cp [local_path] rabbitmq:/[container_path]/\n    ##将主机文件copy至rabbitmq容器，目录重命名为[container_path]（注意与非重命名copy的区别）\n    docker cp [local_path] rabbitmq:/[container_path]\n                ', '2021-01-26 03:02:32', '2021年01月', ' ', 5, 3, 2, 5, '/images/docker.jpg');

-- ----------------------------
-- Table structure for resource
-- ----------------------------
DROP TABLE IF EXISTS `resource`;
CREATE TABLE `resource`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源名称',
  `brief` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '资源简介 ',
  `links` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源链接',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resource
-- ----------------------------

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tagname` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT 'tag的图片',
  `created_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tags
-- ----------------------------
INSERT INTO `tags` VALUES (1, 'Java', '/images/Java.jpg', '2016-04-01 21:55:11');
INSERT INTO `tags` VALUES (2, 'NodeJs', '/images/nodejs.png', '2016-05-18 21:33:58');
INSERT INTO `tags` VALUES (3, 'git', '/images/git.jpg', '2021-01-26 02:29:02');
INSERT INTO `tags` VALUES (4, 'nginx', '/images/nginx.jpg', '2021-01-26 02:40:23');
INSERT INTO `tags` VALUES (5, 'docker', '/images/docker.jpg', '2021-01-26 03:01:13');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录名称',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `created_at` int(11) NULL DEFAULT NULL,
  `updated_at` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'HelloZzzzz', '123321', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
