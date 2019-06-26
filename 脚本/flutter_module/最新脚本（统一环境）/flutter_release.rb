# 解析文件内容为字典数组
# 文件内容格式为  A=B换行C=D   的类型
# 如 A=B
#    C=D
# 解析为:
# {"A"="B","C"="D"}

def parse_KV_file(file, separator='=')
    file_abs_path = File.expand_path(file)
    if !File.exists? file_abs_path
        return [];
    end
    pods_array = []
    skip_line_start_symbols = ["#", "/"]
    File.foreach(file_abs_path) { |line|
        next if skip_line_start_symbols.any? { |symbol| line =~ /^\s*#{symbol}/ }
        plugin = line.split(pattern=separator)
        if plugin.length == 2
            podname = plugin[0].strip()
            path = plugin[1].strip()
            podpath = File.expand_path("#{path}", file_abs_path)
            pods_array.push({:name => podname, :path => podpath});
         else
            puts "Invalid plugin specification: #{line}"
        end
    }
    return pods_array
end


# 这是个函数，功能是从flutter工程生成的iOS依赖目录中的Generated.xcconfig文件解析
# FLUTTER_ROOT目录，也就是你安装的flutter SDKf根目录
def flutter_root()

    generated_xcode_build_settings = parse_KV_file(File.join(File.join('.ios', 'Flutter', 'Generated.xcconfig')))
    if generated_xcode_build_settings.empty?
        puts "Generated.xcconfig 必须存在！！！如果没有执行，请执行flutter packages get"
        exit
    end
    generated_xcode_build_settings.map { |p|
        if p[:name] == 'FLUTTER_ROOT'
            return p[:path]
        end
    }
end

def start()
    root_flutter = flutter_root()
    puts "+++++"+root_flutter

    puts "\n执行iOSshell脚本"
    `sh build_ios.sh -m release -r #{root_flutter}`

#    puts "\n执行安卓shell脚本"
#    `sh gradle_test.sh`
end

start()
