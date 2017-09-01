class  OptimacmsBackups::Admin::BackupsController < Optimacms::Admin::AdminBaseController

  def index

    @list_backups = {
        'db'=>init_list('db_backup'),
        'app_files'=>init_list('app_files_backup'),
        'user_files'=>init_list('user_files_backup'),
    }
  end

  def init_list(t)
    res = []

    #
    files = []

    Dir["#{dir_backups}#{t}/**/*.tar"].each do |f|
      files << f
    end

    files = files.sort_by{ |x| File.mtime(x) }.reverse

    res = files.map do |f|
      r = {}
      r[:shortpath] = f.gsub /#{dir_backups}/, ''
      r[:path] = f
      r[:size] = File.size(f)

      r
    end


    res
  end


  def perform
    t = params[:t] || 'full'

    if t=='full'
      @res = perform_backup_full
    else
      @res = perform_backup(t)
    end



    respond_to do |format|
      format.html {      }
      format.json{        render :json=>@res      }
    end
  end


  def download
    f = params[:f]

    path = File.join(dir_backups, f)

    send_data File.read(path), filename: f
  end

  def delete
    f =  CGI::unescape(params[:f])
    @res = delete_backup(f)

    if @res[:res]==0
      raise 'Error deleting file'
    end

    #
    respond_to do |format|
      format.html {      }
      format.js{ }
      format.json{        render :json=>@res      }
    end
  end


  private





  def perform_backup_full
    res1 = perform_backup('db')
    res2 = perform_backup('app_files')
    res3 = perform_backup('user_files')


    {res: (res1[:res]==1 && res2[:res]==1 && res3[:res]==1 ? 1 : 0), output: ""}
  end

  def perform_backup(t)
    cmd = %Q(app_env=#{Rails.env} bundle exec backup perform -t #{t}_backup --root-path backup 2>&1)

    output = ''

    Bundler.with_clean_env do
      output = `#{cmd}`
    end


    {res: 1, output: output}
  end


  def delete_backup(f)
    path = File.join(dir_backups, f)

    File.delete(path)

    return {res:1 , output: "deleted"}
  rescue Exception => e
    return {res: 0, output: "error"}
  end


  def dir_backups
    OptimacmsBackups.backups_config['dir_backups_base']

  end

end

