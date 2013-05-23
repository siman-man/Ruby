class LispEvaluator
  class ChainHash
    def initialize hash
      @parent=hash
      @hash={ }
    end
    def []= key,value
      @hash[key]=value
    end
    def [] key
      @hash[key]||@parent[key]
    end
  end

  def defun name,*args
    code=args.pop
    argument_list=args
    @methods[name]=->(hash,*args){
      hash=ChainHash.new hash
      argument_list.zip(args).each{ |key,code|
        hash[key]=run code,hash
      }
      run code,hash
    }
    true
  end

  def method_missing name,*args
    a = {name:name,args:args}
    p a
  end

  def run code,hash
    if code.class==Symbol
      hash[code]
    elsif code.class==Hash
      @methods[code[:name]].call hash,*code[:args]
    else
      code
    end
  end
  def initialize
    @methods={ }
    @methods[:cond]=->(hash,a,b,c){
      if run a,hash
        run b,hash
      else
        run c,hash
      end
    }
    @methods[:cons]=->(hash,a,b){
      [run(a,hash),run(b,hash)]
    }
    @methods[:eq]=->(hash,a,b){
      run(a,hash)==run(b,hash)
    }
    @methods[:mult]=->(hash,a,b){
      run(a,hash)*run(b,hash)
    }
    @methods[:minus]=->(hash,a,b){
      run(a,hash)-run(b,hash)
    }
    @methods[:add]=->(hash,a,b){
      run(a,hash)+run(b,hash)
    }
    @methods[:lt]=->(hash,a,b){
      run(a,hash)<run(b,hash)
    }
    @methods[:le]=->(hash,a,b){
      run(a,hash)>run(b,hash)
    }
  end
end

@lispevaluator=LispEvaluator.new
def LISP(&block)
  code=@lispevaluator.instance_eval(&block)
  p @lispevaluator.run(code,{})
end
