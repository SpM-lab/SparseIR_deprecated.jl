using PyCall
import VersionParsing: vparse

const min_sparse_ir_version = "0.9.2"

function check_version_sparse_ir()
    sparse_ir = pyimport("sparse_ir")
    if vparse(sparse_ir.__version__) < vparse(min_sparse_ir_version)
        error("sparse-ir v$(sparse_ir.__version__) is found, but required version >=$(min_sparse_ir_version)! " *
              "PyCall was built with $(PyCall.python). " *
              "If you are using the Conda backend for PyCall, try \"using Conda;Conda.update()\" on the Julia REPL. " *
              "If not, try \"pip3 install -U sparse-ir\". ")
    end
end
